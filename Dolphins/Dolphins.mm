//
//  Dolphins.m
//  Dolphins
//
//  Created by XBK on 2022/4/24.
//


#import <Foundation/Foundation.h>

#import "FloatView.h"
#import "OverlayView.h"

#include "dolphins.h"

#import <mach-o/dyld.h>

#include <stdio.h>

#include <vector>

#include <iostream>

#include "module_tools.h"

#include "pubg_offset.h"

#include "memory_tools.h"

#include "dobby.h"

#include "log.h"

#include "hook.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
using namespace std;

//模块功能控制器
ModuleControl moduleControl;
//内存读写
MemoryTools memoryTools;


//掩体判断函数原型
bool (*LineOfSightTo)(void *controller, void *actor, ImVec3 bone_point, bool ischeck);

//移动X轴
void (*AddControllerYawInput)(void *actot, float val);

//移动Y轴
void (*AddControllerRollInput)(void *actot, float val);

//旋转
void (*AddControllerPitchInput)(void *actot, float val);

struct {
    //ue4入口
    uintptr_t libAddr = 0;
    //矩阵地址
    uintptr_t matrixAddr;
    //Name地址
    uintptr_t gnameAddr;
    //玩家控制器
    uintptr_t playerController;
    //玩家控制器类名
    string playerControllerClassName;
    //相机管理器
    uintptr_t cameraManager;
    //相机管理器类名
    string cameraManagerClassName;
    //自己指针
    uintptr_t selfAddr;
    //静态数据列表
    vector<StaticPlayerData> playerDataList;
    vector<StaticMaterialData> materialDataList;
    //可视烟雾弹列表
    vector<StaticMaterialData> smokeList;
} staticData;

//UI入口函数
static void didFinishLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {
 //   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //Esp绘制
    DrawWindow* drawWindow = [[DrawWindow alloc] initWithFrame:&moduleControl];
    //菜单
    MenuWindow* menuWindow = [[MenuWindow alloc] initWithFrame:&moduleControl];
    //覆盖图层
    OverlayView* overlayView = [[OverlayView alloc] initWithFrame:[UIScreen mainScreen].bounds:&moduleControl:drawWindow:menuWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:overlayView];
    //小按钮
    FloatView* floatView = [[FloatView alloc] initWithFrame:CGRectMake(489, 58, 45, 45):&moduleControl];
    [[UIApplication sharedApplication].keyWindow addSubview:floatView];
  //   });
     }

//库入口函数
__attribute__((constructor)) static void initialize() {
    //加载视图
     CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDrop);
   //加载hook
    loadHook();
    //静态数据线程
    pthread_t staticDataThread;
    pthread_create(&staticDataThread, nullptr, readStaticData, nullptr);
    //自瞄线程
    pthread_t silenceAimbotThread;
    pthread_create(&silenceAimbotThread, nullptr, silenceAimbot, nullptr);
   
}

// 固定数据函数
void *readStaticData(void *) {
    while (true) {
        sleep(4);
        if(moduleControl.systemStatus != TransmissionNormal){
            staticData.libAddr = (uintptr_t)_dyld_get_image_vmaddr_slide(0);
            if(staticData.libAddr != 0){
                moduleControl.systemStatus = TransmissionNormal;
            }
        }else if (moduleControl.systemStatus == TransmissionNormal) {
            //读取矩阵
            staticData.matrixAddr = memoryTools.readPtr(memoryTools.readPtr(staticData.libAddr + PubgOffset::GameMatrixOffset[0]) + PubgOffset::GameMatrixOffset[1]) + PubgOffset::GameMatrixOffset[2];
            //读取gname地址
            staticData.gnameAddr = memoryTools.readPtr(staticData.libAddr + PubgOffset::GameNameOffset);
            //角色控制器
            staticData.playerController = memoryTools.readPtr(memoryTools.readPtr(memoryTools.readPtr(memoryTools.readPtr(staticData.libAddr + PubgOffset::GameWorldOffset) + PubgOffset::PlayerControllerOffset[0]) + PubgOffset::PlayerControllerOffset[1]) + PubgOffset::PlayerControllerOffset[2]);
            //掩体判断
            LineOfSightTo = (bool (*)(void *, void *, ImVec3, bool)) (memoryTools.readPtr(memoryTools.readPtr(staticData.playerController + 0x0) + PubgOffset::PlayerControllerParam::ControllerFunction::LineOfSightToOffset));//0x780
            //自己指针
            staticData.selfAddr = memoryTools.readPtr(staticData.playerController + PubgOffset::PlayerControllerParam::SelfOffset);
            //自瞄函数
            uintptr_t selfFunction = memoryTools.readPtr(staticData.selfAddr + 0);
            AddControllerYawInput = (void (*)(void *, float)) (memoryTools.readPtr(selfFunction + PubgOffset::ObjectParam::PlayerFunction::AddControllerYawInputOffset));//0x780
            AddControllerRollInput = (void (*)(void *, float)) (memoryTools.readPtr(selfFunction + PubgOffset::ObjectParam::PlayerFunction::AddControllerRollInputOffset));//0x780
            AddControllerPitchInput = (void (*)(void *, float)) (memoryTools.readPtr(selfFunction + PubgOffset::ObjectParam::PlayerFunction::AddControllerPitchInputOffset));//0x780
            //相机管理器
            staticData.cameraManager = memoryTools.readPtr(staticData.playerController + PubgOffset::PlayerControllerParam::CameraManagerOffset);
            
            //清空列表
            vector<StaticPlayerData> tmpPlayerDataList;
            vector<StaticMaterialData> tmpMaterialDataList;
            vector<StaticMaterialData> tmpSmokeList;
            //遍历地址
            uintptr_t uLevel = memoryTools.readPtr(memoryTools.readPtr(staticData.libAddr + PubgOffset::GameWorldOffset) + PubgOffset::ULevelOffset);
            //数组
            uintptr_t obectArray = memoryTools.readPtr(uLevel + PubgOffset::ULevelParam::ObjectArrayOffset);
            //成员数量
            int objectCount = memoryTools.readInt(uLevel + PubgOffset::ULevelParam::ObjectCountOffset);
            //开始寻找
            for (int index = 0; index < objectCount; ++index) {
                //对象指针
                uintptr_t objectAddr = memoryTools.readPtr(obectArray + index * 8);
                if (objectAddr <= 0x100000000 || objectAddr >= 0x2000000000 || objectAddr % 8 != 0) {
                    continue;
                }
                
                //对象坐标指针
                uintptr_t coordAddr = memoryTools.readPtr(objectAddr + PubgOffset::ObjectParam::CoordOffset);
                
                string className = getClassName(memoryTools.readInt(objectAddr + PubgOffset::ObjectParam::ClassIdOffset));
                //人
                if (strstr(className.c_str(), "PlayerPawn") != 0 && moduleControl.mainSwitch.playerStatus) {
                    //判断是否是自己队伍
                    if (memoryTools.readInt(memoryTools.readPtr(objectAddr + PubgOffset::ObjectParam::TeamMateOffset) + PubgOffset::ObjectParam::TeamMateParam::TeamNumberOffset) != 0) {
                        continue;
                    }
                    //死亡
                    int status = memoryTools.readInt(objectAddr + PubgOffset::ObjectParam::StatusOffset);
                    if (status == 1048576 || status == 0 || status == 1048577 || status == 1048592 || status == 71894088) {
                        continue;
                    }
                    //队伍ID
                    int team = memoryTools.readInt(objectAddr + PubgOffset::ObjectParam::TeamOffset);
                    if (team < 1) {
                        continue;
                    }
                    StaticPlayerData tmpPlayerData;
                    //对象指针地址
                    tmpPlayerData.addr = objectAddr;
                    //坐标地址
                    tmpPlayerData.coordAddr = coordAddr;
                    //队伍ID
                    tmpPlayerData.team = team;
                    //名字
                    tmpPlayerData.name = getPlayerName(memoryTools.readPtr(objectAddr + PubgOffset::ObjectParam::NameOffset));
                    //人机
                    tmpPlayerData.robot = memoryTools.readInt(objectAddr + PubgOffset::ObjectParam::RobotOffset);
                    
                    tmpPlayerData.status = memoryTools.readInt(objectAddr + PubgOffset::ObjectParam::StatusOffset);
                    
                    tmpPlayerDataList.push_back(tmpPlayerData);
                    
                } else if (strstr(className.c_str(), "ProjSmoke_BP_C)") != 0) {
                    StaticMaterialData tmpMaterialData;
                    //物资类型
                    tmpMaterialData.type = Warning;
                    //物资ID
                    tmpMaterialData.id = 4;
                    //物资名称
                    tmpMaterialData.name = "[预警]烟雾弹";
                    //对象指针地址
                    tmpMaterialData.addr = objectAddr;
                    //坐标地址
                    tmpMaterialData.coordAddr = coordAddr;
                    
                    tmpSmokeList.push_back(tmpMaterialData);
                } else if (moduleControl.mainSwitch.materialStatus) {
                    MaterialStruct material = isMaterial(className.c_str());
                    if (material.type > -1) {
                        /*if (strstr(material.name, "[狙击枪]M24") != 0) {
                         LOGE("%s 物品Id：%d", material.name, memoryTools.readInt(objectAddr + 0x7D0));
                         }*/
                        StaticMaterialData tmpMaterialData;
                        //物资类型
                        tmpMaterialData.type = material.type;
                        //物资ID
                        tmpMaterialData.id = material.id;
                        //物资名称
                        tmpMaterialData.name = material.name;
                        //对象指针地址
                        tmpMaterialData.addr = objectAddr;
                        //坐标地址
                        tmpMaterialData.coordAddr = coordAddr;
                        
                        if ((material.type == Rifle || material.type == Sniper || material.type == Missile) && memoryTools.readPtr(objectAddr + PubgOffset::ObjectParam::WeaponParam::MasterOffset) != 0) {
                            continue;
                        }
                        tmpMaterialDataList.push_back(tmpMaterialData);
                    }
                }
            }
            //将临时列表赋值给全局列表
            staticData.playerDataList.swap(tmpPlayerDataList);
            staticData.materialDataList.swap(tmpMaterialDataList);
            staticData.smokeList.swap(tmpSmokeList);
        }
    }
    return nullptr;
}

//获取帧数据
void readFrameData(ImVec2 screenSize,vector<PlayerData> &playerDataList, vector<MaterialData> &materialDataList) {
    playerDataList.clear();
    materialDataList.clear();
    if (moduleControl.systemStatus == TransmissionNormal) {
        //相机管理器类名
        staticData.cameraManagerClassName = getClassName(memoryTools.readInt(staticData.cameraManager + PubgOffset::ObjectParam::ClassIdOffset));
        //取玩家控制器类名
        staticData.playerControllerClassName = getClassName(memoryTools.readInt(staticData.playerController + PubgOffset::ObjectParam::ClassIdOffset));
        //取Pov
        MinimalViewInfo pov;
        memoryTools.readMemory(staticData.cameraManager + PubgOffset::PlayerControllerParam::CameraManagerParam::PovOffset, sizeof(pov), &pov);
        //自身坐标
        ImVec3 selfCoord = pov.location;
        //读视角角度
        float lateralAngleView = memoryTools.readFloat(staticData.playerController + PubgOffset::PlayerControllerParam::MouseOffset + 0x4) - 90;
        //读取矩阵
        if (moduleControl.mainSwitch.playerStatus) {
            for (auto staticPlayerData: staticData.playerDataList) {
                //判断是否死亡
                int playerStatus = memoryTools.readInt(staticPlayerData.addr + PubgOffset::ObjectParam::StatusOffset);
                if (playerStatus == 1048576 || playerStatus == 0 || playerStatus == 1048577 || playerStatus == 1048592 || playerStatus == 71894088) {
                    continue;
                }
                //坐标
                ImVec3 objectCoord;
                memoryTools.readMemory(staticPlayerData.coordAddr + PubgOffset::ObjectParam::CoordParam::CoordOffset, sizeof(ImVec3), &objectCoord);
                //计算自己到对象的距离
                float objectDistance = get3dDistance(objectCoord, selfCoord, 100);
                if (objectDistance < 0 || objectDistance > 450) {
                    continue;
                }
                //获取对象高度
                float objectHeight = memoryTools.readFloat(staticPlayerData.coordAddr + PubgOffset::ObjectParam::CoordParam::HeightOffset);
                if (objectHeight < 20) {
                    continue;
                }
                PlayerData playerData;
                //角度
                playerData.angle = lateralAngleView - rotateAngle(selfCoord, objectCoord) - 180;
                //雷达坐标
                playerData.radar = rotateCoord(lateralAngleView, ImVec2((selfCoord.x - objectCoord.x) / 200, (selfCoord.y - objectCoord.y) / 200));
                //距离
                playerData.distance = objectDistance;
                //人机
                playerData.robot = staticPlayerData.robot;
                //掩体判断
                
                playerData.visibility = isCoordVisibility(objectCoord);
                if (playerData.visibility && isOnSmoke(objectCoord)) {
                    playerData.visibility = false;
                }
                
                //判断一下高度
                if (objectHeight < 50) {
                    objectHeight -= 18;
                } else if (objectHeight > 80) {
                    objectHeight += 12;
                }
                //队伍ID
                playerData.team = staticPlayerData.team;
                //血量
                playerData.hp = memoryTools.readFloat(staticPlayerData.addr + PubgOffset::ObjectParam::HpOffset);
                //取敌人动作
     //           NSLog(@"****： %d",statusName);
                uintptr_t statusAddr = memoryTools.readPtr(staticPlayerData.addr + PubgOffset::ObjectParam::StatusOffset);
                if (statusAddr == 2097168) {
                playerData.statusName = "开车";
                }
                if (statusAddr == 262208) {
                playerData.statusName = "打药";
                }
                if (statusAddr == 33554449) {
                playerData.statusName = "跳伞";
                }
                if (statusAddr == 262160) {
                playerData.statusName = "站立";
                }
                if (statusAddr == 16) {
                playerData.statusName = "站立";
                }
                if (statusAddr == 524288) {
                playerData.statusName = "击倒";
                }
                if (statusAddr == 147) {
                playerData.statusName = "跳跃";
                }
                if (statusAddr == 529) {
                playerData.statusName = "走路换弹";
                }
                if (statusAddr == 35) {
                playerData.statusName = "蹲跑";
                }
                if (statusAddr == 8205) {
                playerData.statusName = "开火";
                }
                if (statusAddr == 33) {
                playerData.statusName = "蹲走";
                }
                if (statusAddr == 65568) {
                playerData.statusName = "蹲下丢雷";
                }
                if (statusAddr == 65600) {
                playerData.statusName = "趴下丢雷";
                }
                if (statusAddr == 1088) {
                playerData.statusName = "趴下开镜";
                }
                if (statusAddr == 1056) {
                playerData.statusName = "蹲下开镜";
                }
                if (statusAddr == 18) {
                playerData.statusName = "站立";
                }
                if (statusAddr == 32784) {
                playerData.statusName = "挥拳";
                }
                if (statusAddr == 23) {
                playerData.statusName = "拿枪";
                }
                if (statusAddr == 1073741840) {
                playerData.statusName = "开火";
                }
                if (statusAddr == 16777219) {
                playerData.statusName = "游泳";
                }
                if (statusAddr == 524289) {
                playerData.statusName = "击倒";
                }
                if (statusAddr == 8205) {
                playerData.statusName = "开火";
                }
                if (statusAddr == 1040) {
                playerData.statusName = "开镜";
                               }
                if (statusAddr == 272) {
                playerData.statusName = "开枪";
                               }
                if (statusAddr == 4112) {
                playerData.statusName = "歪头";
                               }
                if (statusAddr == 19) {
                playerData.statusName = "奔跑";
                               }
                if (statusAddr == 6552) {
                playerData.statusName = "拉手雷";
                               }
                if (statusAddr == 64) {
                playerData.statusName = "趴着";
                               }
                if (statusAddr == 32) {
                playerData.statusName = "蹲着";
                               }
                if (statusAddr == 144) {
                playerData.statusName = "跳跃";
                               }
                if (statusAddr == 4128) {
                playerData.statusName = "蹲着歪头";
                               }
                if (statusAddr == 4384) {
                playerData.statusName = "蹲着开火";
                               }
                if (statusAddr == 528) {
                playerData.statusName = "换弹中";
                               }
                if (statusAddr == 320) {
                playerData.statusName = "趴着开火";
                               }
                if (statusAddr == 288) {
                playerData.statusName = "蹲着开火";
                               }
                if (statusAddr == 576) {
                playerData.statusName = "趴着换弹";
                               }
                if (statusAddr == 544) {
                playerData.statusName = "蹲着换弹";
                               }
                if (statusAddr == 67108880) {
                playerData.statusName = "翻墙中";
                               }
                if (statusAddr == 273) {
                playerData.statusName = "走着开火";
                               }
                if (statusAddr == 4194320) {
                playerData.statusName = "乘坐";
                               }
                if (statusAddr == 17) {
                playerData.statusName = "行走";
                               }
                
                
                
                //取对手手持武器
                uintptr_t weaponAddr = memoryTools.readPtr(staticPlayerData.addr + PubgOffset::ObjectParam::WeaponOneOffset);
                if (weaponAddr == 0) {
                    playerData.weaponName = "拳头";
                } else {
                string className = getClassName(memoryTools.readInt(weaponAddr + PubgOffset::ObjectParam::ClassIdOffset));
                MaterialStruct weaponName = isWeapon(className.c_str());
                if (weaponName.id != 0) {
                    playerData.weaponName = weaponName.name;
                } else {
                playerData.weaponName = "[步枪]M762";
                    }
                }
                //对象名字
                playerData.name = staticPlayerData.name;
                //屏幕XY
                playerData.screen = worldToScreen(objectCoord, pov, screenSize);//X
                //宽度和高度
                ImVec2 width = worldToScreen(ImVec3(objectCoord.x,objectCoord.y,objectCoord.z + 100), pov,screenSize);
                ImVec2 height = worldToScreen(ImVec3(objectCoord.x,objectCoord.y,objectCoord.z + objectHeight), pov,screenSize);
                playerData.size.x = (playerData.screen.y - width.y) / 2;
                playerData.size.y = playerData.screen.y - height.y;
                
                uintptr_t meshAddr = memoryTools.readPtr(staticPlayerData.addr + PubgOffset::ObjectParam::MeshOffset);
                uintptr_t humanAddr = meshAddr + PubgOffset::ObjectParam::MeshParam::HumanOffset;
                uintptr_t boneAddr = memoryTools.readPtr(meshAddr + PubgOffset::ObjectParam::MeshParam::BonesOffset) + 48;
                //判断是否需要骨骼掩体判断
                BonesData bonesData;
                if (getBone2d(pov, screenSize,humanAddr, boneAddr, 5, bonesData.head))//头
                    if (getBone2d(pov,screenSize, humanAddr, boneAddr, 4, bonesData.pit))//胸口
                        if (getBone2d(pov,screenSize, humanAddr, boneAddr, 1, bonesData.pelvis))//屁股
                            if (getBone2d(pov,screenSize, humanAddr, boneAddr, 11, bonesData.lcollar))//左肩
                                if (getBone2d(pov, screenSize,humanAddr, boneAddr, 32, bonesData.rcollar))//右肩
                                    if (getBone2d(pov,screenSize, humanAddr, boneAddr, 12, bonesData.lelbow))//左手肘
                                        if (getBone2d(pov,screenSize, humanAddr, boneAddr, 33, bonesData.relbow))//右手肘
                                            if (getBone2d(pov,screenSize, humanAddr, boneAddr, 63, bonesData.lwrist))//左手腕
                                                if (getBone2d(pov,screenSize, humanAddr, boneAddr, 62, bonesData.rwrist))//右手腕
                                                    if (getBone2d(pov, screenSize,humanAddr, boneAddr, 52, bonesData.lthigh))//左大腿
                                                        if (getBone2d(pov,screenSize, humanAddr, boneAddr, 56, bonesData.rthigh))//右大腿
                                                            if (getBone2d(pov,screenSize, humanAddr, boneAddr, 53, bonesData.lknee))//左膝盖
                                                                if (getBone2d(pov,screenSize, humanAddr, boneAddr, 57, bonesData.rknee))//右膝盖
                                                                    if (getBone2d(pov,screenSize, humanAddr, boneAddr, 54, bonesData.lankle))//左脚腕
                                                                        if (getBone2d(pov,screenSize, humanAddr, boneAddr, 58, bonesData.rankle))//右脚腕
                                                                            playerData.bonesData = bonesData;
                playerDataList.push_back(playerData);
            }
        }
        if (moduleControl.mainSwitch.materialStatus) {
            for (auto staticMaterialData: staticData.materialDataList) {
                string className = getClassName(memoryTools.readInt(staticMaterialData.coordAddr + PubgOffset::ObjectParam::ClassIdOffset));
                if (isRecycled(className.c_str())) {
                    continue;
                }
                //坐标
                ImVec3 objectCoord;
                memoryTools.readMemory(staticMaterialData.coordAddr + PubgOffset::ObjectParam::CoordParam::CoordOffset, sizeof(ImVec3), &objectCoord);
                //计算自己到对象的距离
                float objectDistance = get3dDistance(objectCoord, selfCoord, 100);
                if (staticMaterialData.type > 1 && staticMaterialData.type < All && objectDistance > 100) {
                    continue;
                }
                //判断数据是否是0
                if (staticMaterialData.type < 0 && staticMaterialData.type > All) {
                    continue;
                }
                //判断开关 数组下标是否超出
                if (!moduleControl.materialSwitch[staticMaterialData.type]) {
                    continue;
                }
                MaterialData materialData;
                //物资类型
                materialData.type = staticMaterialData.type;
                //物资ID
                materialData.id = staticMaterialData.id;
                //物资名字
                materialData.name = staticMaterialData.name;
                //距离
                materialData.distance = objectDistance;
                //屏幕坐标
                materialData.screen = worldToScreen(objectCoord, pov, screenSize);//X
                
                materialDataList.push_back(materialData);
                
                if (staticMaterialData.type == Airdrop) {
                    //屏幕坐标
                    ImVec2 goodsListScreen = worldToScreen(objectCoord, pov, screenSize);//X
                    
                    if (get2dDistance(screenSize, goodsListScreen) < 150) {
                        int goodsListValidCount = 0;
                        //盒子遍历
                        uintptr_t goodsListArray = memoryTools.readPtr(staticMaterialData.addr + PubgOffset::ObjectParam::GoodsListOffset);
                        //盒子物资数量
                        int goodsListCount = memoryTools.readInt(staticMaterialData.addr + PubgOffset::ObjectParam::GoodsListOffset + sizeof(uintptr_t));
                        //开始遍历
                        for (int index = 0; index < goodsListCount; index++) {
                            if (index > 100) {
                                break;
                            }
                            //对象ID
                            int goodsListId = memoryTools.readInt(goodsListArray + 0x4 + index * PubgOffset::ObjectParam::GoodsListParam::DataBase);
                            
                            MaterialStruct goods = isBoxMaterial(goodsListId);
                            if (goods.type == -1) {
                                continue;
                            }
                            
                            memset(&materialData, 0, sizeof(materialData));
                            
                            goodsListValidCount++;
                            //物资类型
                            materialData.type = goods.type;
                            //物资ID
                            materialData.id = goods.id;
                            //物资名字
                            materialData.name = goods.name;
                            //距离
                            materialData.distance = -100;
                            //屏幕坐标
                            materialData.screen.x = goodsListScreen.x;
                            materialData.screen.y = goodsListScreen.y - 32 * (goodsListValidCount);
                            
                            materialDataList.push_back(materialData);
                        }
                    }
                }
            }
        }
        
    }
}

//自瞄
void *silenceAimbot(void *) {
    ImVec2 screenSize = ImVec2([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    while (true) {
        usleep(16666);
        if (moduleControl.systemStatus == TransmissionNormal && moduleControl.mainSwitch.aimbotStatus/* && softWareData.loginStatus*/) {
            //武器指针
            uintptr_t weaponAddr = memoryTools.readPtr(staticData.selfAddr + PubgOffset::ObjectParam::WeaponOneOffset);
            //自瞄开关
            bool enabledAimbot = true;
            //判断自瞄启动模式
            switch (moduleControl.aimbotController.aimbotMode) {
                case 0:
                    //开镜自瞄
                    enabledAimbot = memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenTheSightOffset) == 257 || memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenTheSightOffset) == 1;
                    break;
                case 1:
                    //开火自瞄
                    enabledAimbot = memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenFireOffset) == 1;
                    break;
                case 2:
                    //开镜开火自瞄
                    enabledAimbot = memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenTheSightOffset) == 257 || memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenTheSightOffset) == 1 || memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenFireOffset) == 1;
                    break;
                case 3:
                    //判断枪械是单发还是全自动
                    if (memoryTools.readInt(weaponAddr + PubgOffset::ObjectParam::WeaponParam::ShootModeOffset) >= 1024) {
                        //全自动用开火
                        enabledAimbot = memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenFireOffset) == 1;
                    } else {
                        //单发连发用开镜
                        enabledAimbot = memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenTheSightOffset) == 257 || memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenTheSightOffset) == 1;
                    }
                    break;
            }
            //启动自瞄
            if (enabledAimbot) {
                //取Pov
                MinimalViewInfo pov;
                memoryTools.readMemory(staticData.cameraManager + PubgOffset::PlayerControllerParam::CameraManagerParam::PovOffset, sizeof(pov), &pov);
                //自身坐标
                ImVec3 selfCoord = pov.location;
                //复位自瞄范围
                float aimbotRadius = moduleControl.aimbotController.aimbotRadius;
                //自瞄对象定义
                StaticPlayerData aimbotPlayerData;
                //自瞄对象的指针置0
                aimbotPlayerData.addr = 0;
                //自瞄对象坐标,指定部位的坐标
                ImVec3 aimbotCoord = ImVec3(0,0,0);
                //循环人物对象列表
                for (auto staticPlayerData: staticData.playerDataList) {
                    //判断是否死亡
                    int playerStatus = memoryTools.readInt(staticPlayerData.addr + PubgOffset::ObjectParam::StatusOffset);
                    if (playerStatus == 1048576 || playerStatus == 0 || playerStatus == 1048577 || playerStatus == 1048592 || playerStatus == 71894088) {
                        continue;
                    }
                    //坐标
                    ImVec3 objectCoord;
                    memoryTools.readMemory(staticPlayerData.coordAddr + PubgOffset::ObjectParam::CoordParam::CoordOffset, sizeof(ImVec3), &objectCoord);
                    //计算自己到对象的距离
                    float objectDistance = get3dDistance(objectCoord, selfCoord, 100);
                    if (objectDistance < 0 || objectDistance > 450 || objectDistance > moduleControl.aimbotController.distance) {
                        continue;
                    }
                    //获取对象高度
                    float objectHeight = memoryTools.readFloat(staticPlayerData.coordAddr + PubgOffset::ObjectParam::CoordParam::HeightOffset);
                    if (objectHeight < 20) {
                        continue;
                    }
                    //判断是否倒地
                    if (memoryTools.readFloat(staticPlayerData.addr + PubgOffset::ObjectParam::HpOffset) < 0.5 && moduleControl.aimbotController.fallNotAim) {
                        continue;
                    }
                    //屏幕坐标
                    ImVec2 playerScreen = worldToScreen(objectCoord, pov, screenSize);
                    //模糊自瞄对象
                    float screenDistance;
                    //判断自瞄对象是否在指定屏幕范围
                    if ((screenDistance = get2dDistance(screenSize,playerScreen)) < aimbotRadius) {
                        //骨骼mesh
                        uintptr_t meshAddr = memoryTools.readPtr(staticPlayerData.addr + PubgOffset::ObjectParam::MeshOffset);
                        uintptr_t humanAddr = meshAddr + PubgOffset::ObjectParam::MeshParam::HumanOffset;
                        uintptr_t boneAddr = memoryTools.readPtr(meshAddr + PubgOffset::ObjectParam::MeshParam::BonesOffset) + 48;
                        //取自瞄部位 0是优先头部,1是优先身体,3是[全自动武器打身体,单发连发打头],4是只打头,5是只打身体
                        switch (moduleControl.aimbotController.aimbotParts) {
                            case 0: {
                                //判断骨点是否可见
                                int boneIds[] = {5, 3, 1, 11, 32, 12, 33, 63, 62, 52, 56, 53, 57, 54, 58};
                                for (int boneId = 0; boneId < end(boneIds) - begin(boneIds); ++boneId) {
                                    //取骨点
                                    aimbotCoord = getBone(humanAddr, boneAddr, boneIds[boneId]);
                                    //是否可见,可见则赋值给上面的变量
                                    if (isCoordVisibility(aimbotCoord)) {
                                        //自瞄对象数据
                                        aimbotPlayerData = staticPlayerData;
                                        //当前对象所在的屏幕范围
                                        aimbotRadius = screenDistance;
                                        //跳出循环
                                        break;
                                    } else {
                                        //对象坐标置0
                                        aimbotCoord = {0, 0, 0};
                                    }
                                }
                            }
                                //跳出switch
                                break;
                            case 1: {
                                int boneIds[] = {3, 5, 1, 11, 32, 12, 33, 63, 62, 52, 56, 53, 57, 54, 58};
                                for (int boneId = 0; boneId < end(boneIds) - begin(boneIds); ++boneId) {
                                    //取骨点
                                    aimbotCoord = getBone(humanAddr, boneAddr, boneIds[boneId]);
                                    if (isCoordVisibility(aimbotCoord)) {
                                        aimbotPlayerData = staticPlayerData;
                                        aimbotRadius = screenDistance;
                                        break;
                                    } else {
                                        aimbotCoord = {0, 0, 0};
                                    }
                                }
                            }
                                break;
                            case 2: {
                                if (memoryTools.readInt(weaponAddr + PubgOffset::ObjectParam::WeaponParam::ShootModeOffset) >= 1024) {
                                    int boneIds[] = {3, 5, 1, 11, 32, 12, 33, 63, 62, 52, 56, 53, 57, 54, 58};
                                    for (int boneId = 0; boneId < end(boneIds) - begin(boneIds); ++boneId) {
                                        //取骨点
                                        aimbotCoord = getBone(humanAddr, boneAddr, boneIds[boneId]);
                                        if (isCoordVisibility(aimbotCoord)) {
                                            aimbotPlayerData = staticPlayerData;
                                            aimbotRadius = screenDistance;
                                            break;
                                        } else {
                                            aimbotCoord = {0, 0, 0};
                                        }
                                    }
                                } else {
                                    int boneIds[] = {5, 3, 1, 11, 32, 12, 33, 63, 62, 52, 56, 53, 57, 54, 58};
                                    for (int boneId = 0; boneId < end(boneIds) - begin(boneIds); ++boneId) {
                                        //取骨点
                                        aimbotCoord = getBone(humanAddr, boneAddr, boneIds[boneId]);
                                        if (isCoordVisibility(aimbotCoord)) {
                                            aimbotPlayerData = staticPlayerData;
                                            aimbotRadius = screenDistance;
                                            break;
                                        } else {
                                            aimbotCoord = {0, 0, 0};
                                        }
                                    }
                                }
                            }
                                break;
                            case 3: {
                                //取骨点
                                aimbotCoord = getBone(humanAddr, boneAddr, 5);
                                if (isCoordVisibility(aimbotCoord)) {
                                    aimbotPlayerData = staticPlayerData;
                                    aimbotRadius = screenDistance;
                                    break;
                                } else {
                                    aimbotCoord = {0, 0, 0};
                                }
                            }
                                break;
                            case 4: {
                                //坐标
                                aimbotCoord = getBone(humanAddr, boneAddr, 3);
                                if (isCoordVisibility(aimbotCoord)) {
                                    aimbotPlayerData = staticPlayerData;
                                    aimbotRadius = screenDistance;
                                    break;
                                } else {
                                    aimbotCoord = {0, 0, 0};
                                }
                            }
                                break;
                        }
                    }
                    //switch结束
                }
                //判断是否有自瞄对象,有则开始自瞄
                if (aimbotPlayerData.addr != 0 && aimbotCoord.x != 0 && aimbotCoord.y != 0 && aimbotCoord.z != 0) {
                    //判断是否在烟雾内
                    if (moduleControl.aimbotController.smoke) {
                        if (isOnSmoke(aimbotCoord)) {
                            aimbotCoord = {0, 0, 0};
                            continue;
                        }
                    }
//                    float distance = get3dDistance(selfCoord, aimbotCoord, 100);
                    //武器属性指针
                    uintptr_t weaponAttrAddr = memoryTools.readPtr(weaponAddr + PubgOffset::ObjectParam::WeaponParam::WeaponAttrOffset);
                    //子弹速度
                    float bulletSpeed = memoryTools.readFloat(weaponAttrAddr + PubgOffset::ObjectParam::WeaponParam::WeaponAttrParam::BulletSpeedOffset);
                    //子弹飞行时间
                    float bulletFlyTime = get3dDistance(selfCoord, aimbotCoord, bulletSpeed) * 1.2;
                    //移动加坐标
                    ImVec3 moveCoord;
                    memoryTools.readMemory(aimbotPlayerData.addr + PubgOffset::ObjectParam::MoveCoordOffset, 12, &moveCoord);
                    //预判坐标
                    aimbotCoord.x += moveCoord.x * bulletFlyTime;
                    aimbotCoord.y += moveCoord.y * bulletFlyTime;
                    aimbotCoord.z += moveCoord.z * bulletFlyTime;
                    
                    //旋转坐标,计算当前自己位置和自瞄对象位置的角度
                    ImVec2 aimbotMouse = rotateAngleView(selfCoord, aimbotCoord);
                    //判断下蹲
                    float selfStatus = memoryTools.readFloat(memoryTools.readPtr(staticData.selfAddr + PubgOffset::ObjectParam::CoordOffset) + PubgOffset::ObjectParam::CoordParam::HeightOffset);
                    //获取武器的类名
                    string className = getClassName(memoryTools.readInt(weaponAddr + PubgOffset::ObjectParam::ClassIdOffset));
                    //用自己的高度来判断是否是站立
                    if (selfStatus > 47) {
                        //不同武器调整准星
                        if (strstr(className.c_str(), "Sniper_AWM") != 0) {
                            aimbotMouse.x += 0.06;
                            aimbotMouse.y -= 0.06;
                        } else if (strstr(className.c_str(), "Sniper_AMR") != 0) {
                            aimbotMouse.x -= 0.075;
                            aimbotMouse.y -= 0.035;
                        } else if (strstr(className.c_str(), "Sniper_M24") != 0) {
                            aimbotMouse.x += 0.04;
                            aimbotMouse.y -= 0.03;
                        } else if (strstr(className.c_str(), "Sniper_Kar98k") != 0) {
                            aimbotMouse.x += 0.05;
                            aimbotMouse.y -= 0.02;
                        } else if (strstr(className.c_str(), "Sniper_Mosin") != 0) {
                            aimbotMouse.x += 0.04;
                            aimbotMouse.y -= 0.05;
                        } else if (strstr(className.c_str(), "Sniper_Mk14") != 0) {
                            aimbotMouse.x += 0.05;
                            aimbotMouse.y -= 0.05;
                        } else if (strstr(className.c_str(), "Sniper_QBU") != 0) {
                            aimbotMouse.x += 0.055;
                            aimbotMouse.y -= 0.085;
                        } else if (strstr(className.c_str(), "Sniper_SKS") != 0) {
                            aimbotMouse.x += 0.06;
                            aimbotMouse.y -= 0.085;
                        } else if (strstr(className.c_str(), "Sniper_SLR") != 0) {
                            aimbotMouse.x += 0.055;
                            aimbotMouse.y -= 0.03;
                        } else if (strstr(className.c_str(), "Sniper_Mini14") != 0) {
                            aimbotMouse.x += 0.015;
                            aimbotMouse.y -= 0.05;
                            
                        } else if (strstr(className.c_str(), "Rifle_QBZ") != 0) {
                            aimbotMouse.x += 0.045;
                            aimbotMouse.y -= 0.09;
                        } else if (strstr(className.c_str(), "Rifle_G36") != 0) {
                            aimbotMouse.x += 0.02;
                            aimbotMouse.y -= 0.055;
                        } else if (strstr(className.c_str(), "Rifle_Groza") != 0) {
                            aimbotMouse.x += 0.03;
                            aimbotMouse.y -= 0.065;
                        } else if (strstr(className.c_str(), "Rifle_AUG") != 0) {
                            aimbotMouse.x += 0.015;
                            aimbotMouse.y -= 0.08;
                        } else if (strstr(className.c_str(), "Rifle_M16A4") != 0) {
                            aimbotMouse.x += 0.04;
                            aimbotMouse.y -= 0.07;
                        } else if (strstr(className.c_str(), "Rifle_AKM") != 0) {
                            aimbotMouse.x += 0.04;
                            aimbotMouse.y -= 0.07;
                        } else if (strstr(className.c_str(), "Rifle_SCAR") != 0) {
                            aimbotMouse.x += 0.02;
                            aimbotMouse.y -= 0.085;
                        } else if (strstr(className.c_str(), "Rifle_M416") != 0) {
                            aimbotMouse.x += 0.02;
                            aimbotMouse.y -= 0.08;
                        } else if (strstr(className.c_str(), "Rifle_M762") != 0) {
                            aimbotMouse.x += 0.03;
                            aimbotMouse.y -= 0.07;
                        } else if (strstr(className.c_str(), "Other_M249") != 0) {
                            aimbotMouse.x += 0.025;
                            aimbotMouse.y -= 0.06;
                        } else if (strstr(className.c_str(), "Other_MG3") != 0) {
                            aimbotMouse.x += 0.03;
                            aimbotMouse.y -= 0.07;
                        } else if (strstr(className.c_str(), "Other_DP28") != 0) {
                            aimbotMouse.x += 0.045;
                            aimbotMouse.y -= 0.095;
                        }
                    }
                    
                    //压枪
                    if (memoryTools.readInt(staticData.selfAddr + PubgOffset::ObjectParam::OpenFireOffset) == 1) {
                        //距离运算,压枪的幅度
                        float recoilTimes = 4.5 - get3dDistance(selfCoord, aimbotCoord, 10000);
                        recoilTimes += get3dDistance(selfCoord, aimbotCoord, 10000) * 0.2;
                        //后坐力
                        float recoil = memoryTools.readFloat(weaponAttrAddr + PubgOffset::ObjectParam::WeaponParam::WeaponAttrParam::RecoilOffset);//站立
                        //指定武器调整后坐力
                        if (strstr(className.c_str(), "Sniper_VSS") != 0) {
                            recoil *= 0.4;
                        } else if (strstr(className.c_str(), "Rifle_G36") != 0) {
                            recoil *= 0.6;
                        } else if (strstr(className.c_str(), "Rifle_VAL") != 0) {
                            recoil *= 0.45;
                        } else if (strstr(className.c_str(), "Rifle_AUG") != 0) {
                            recoil *= 0.7;
                        } else if (strstr(className.c_str(), "Rifle_AKM") != 0) {
                            recoil *= 1.15;
                        } else if (strstr(className.c_str(), "Other_MG3") != 0) {
                            recoil *= 0.2;
                        } else if (strstr(className.c_str(), "Other_DP28") != 0) {
                            recoil *= 0.3;
                        }
                        //蹲下
                        if (selfStatus < 50.0f) {
                            //调整指定武器后坐力和准星
                            if (strstr(className.c_str(), "Rifle_M762") != 0) {
                                recoil *= 0.55;
                                aimbotMouse.x += 0.2;
                            } else if (strstr(className.c_str(), "Other_M249") != 0) {
                                recoil *= 0.6;
                                aimbotMouse.x += 0.08;
                            } else {
                                recoil *= 0.35;
                            }
                        }
                        //压枪
                        aimbotMouse.y -= recoilTimes * recoil;
                    }
                    
                    //判断是否是有效数
                    if (!isfinite(aimbotMouse.x) || !isfinite(aimbotMouse.y)) {
                        continue;
                    }
                    //准星移动的角度
                    ImVec2 aimbotMouseMove;
                    //计算角度
                    //getAngleDifference 读内存里的准星角度和计算得到的准星角度进行运算,得到角度差
                    //change是调整角度 正数变负数, 负数变整数
                    // * moduleControl.aimbotController.aimbotIntensity 就是 * 0.35 让准星慢慢移动到指定位置,类似触摸自瞄  * 1就是强锁了
                    //这里是类触摸的关键,* 0.35就是得到的角度差的35%,一次移动角度差的35% 就让准星慢慢移动到敌人了
                    aimbotMouseMove.x = change(getAngleDifference(aimbotMouse.x, memoryTools.readFloat(staticData.playerController + PubgOffset::PlayerControllerParam::MouseOffset + 0x4)) * moduleControl.aimbotController.aimbotIntensity);
                    aimbotMouseMove.y = change(getAngleDifference(aimbotMouse.y, memoryTools.readFloat(staticData.playerController + PubgOffset::PlayerControllerParam::MouseOffset)) * moduleControl.aimbotController.aimbotIntensity);
                    //判断计算得到的角度是不是一个有效数
                    if (!isfinite(aimbotMouseMove.x) || !isfinite(aimbotMouseMove.y)) {
                        continue;
                    }
                    //移动鼠标,我这里用的增量自瞄,是传入的角度差 比如游戏的角度在180度,我上面计算的角度差是-30 这里传入-30就让180-30了
                    if (AddControllerYawInput != NULL) {
                        AddControllerYawInput(reinterpret_cast<void *>(staticData.selfAddr), aimbotMouseMove.x);
                    }
                    if (AddControllerRollInput != NULL) {
                        AddControllerRollInput(reinterpret_cast<void *>(staticData.selfAddr), aimbotMouseMove.y);
                    }
                    if (AddControllerPitchInput != NULL) {
                        AddControllerPitchInput(reinterpret_cast<void *>(staticData.selfAddr), 0);
                    }
                }
            }
        }
    }
}

//isVisiblePoint
bool isCoordVisibility(ImVec3 coord) {
    if (LineOfSightTo == nullptr || !isfinite(coord.x) || !isfinite(coord.y) || !isfinite(coord.z)) {
        return false;
    }
    if (strstr(staticData.cameraManagerClassName.c_str(), "PlayerCameraManager") != 0 && strstr(staticData.playerControllerClassName.c_str(), "PlayerController") != 0) {
        return LineOfSightTo(reinterpret_cast<void *>(staticData.playerController), reinterpret_cast<void *>(staticData.cameraManager), coord, false);
    }
    return false;
}

bool isOnSmoke(ImVec3 coord) {
    for (StaticMaterialData smoke: staticData.smokeList) {
        //坐标
        ImVec3 smokeCoord;
        memoryTools.readMemory(smoke.coordAddr + PubgOffset::ObjectParam::CoordParam::CoordOffset, 30, &smokeCoord);
        if (get3dDistance(smokeCoord, coord, 100) < 4) {
            return true;
        }
    }
    return false;
}

//获取玩家名字
char *getPlayerName(uintptr_t addr) {
    char *buf = (char *) malloc(448);
    unsigned short buf16[16] = {0};
    memoryTools.readMemory(addr, 28, buf16);
    unsigned short *tempbuf16 = buf16;
    char *tempbuf8 = buf;
    char *buf8 = tempbuf8 + 32;
    while (tempbuf16 < tempbuf16 + 28) {
        if (*tempbuf16 <= 0x007F && tempbuf8 + 1 < buf8) {
            *tempbuf8++ = (char) *tempbuf16;
        } else if (*tempbuf16 >= 0x0080 && *tempbuf16 <= 0x07FF && tempbuf8 + 2 < buf8) {
            *tempbuf8++ = (*tempbuf16 >> 6) | 0xC0;
            *tempbuf8++ = (*tempbuf16 & 0x3F) | 0x80;
        } else if (*tempbuf16 >= 0x0800 && *tempbuf16 <= 0xFFFF && tempbuf8 + 3 < buf8) {
            *tempbuf8++ = (*tempbuf16 >> 12) | 0xE0;
            *tempbuf8++ = ((*tempbuf16 >> 6) & 0x3F) | 0x80;
            *tempbuf8++ = (*tempbuf16 & 0x3F) | 0x80;
        } else {
            break;
        }
        tempbuf16++;
    }
    return buf;
}
//获取类名
char *getClassName(int classId) {
    char *buf = (char *) malloc(64);
    if (classId > 0 && classId < 2000000) {
        int page = classId / 16384;
        int index = classId % 16384;
        uintptr_t pageAddr = memoryTools.readPtr(staticData.gnameAddr + page * sizeof(uintptr_t));
        uintptr_t nameAddr = memoryTools.readPtr(pageAddr + index * sizeof(uintptr_t)) + PubgOffset::ObjectParam::ClassNameOffset;
        memoryTools.readMemory(nameAddr, 64, buf);
    }
    return buf;
}

//取骨骼3d坐标
ImVec3 getBone(uintptr_t human, uintptr_t bones, int part) {
    Ue4Transform actorftf;
    memoryTools.readMemory(human, sizeof(ImVec4), &actorftf.rotation);
    memoryTools.readMemory(human + 0x10, sizeof(ImVec3), &actorftf.translation);
    memoryTools.readMemory(human + 0x20, sizeof(ImVec3), &actorftf.scale3d);
    
    Ue4Matrix actormatrix = transformToMatrix(actorftf);
    
    Ue4Transform boneftf;
    memoryTools.readMemory(bones + part * 48, sizeof(ImVec4), &boneftf.rotation);
    memoryTools.readMemory(bones + part * 48 + 0x10, sizeof(ImVec3), &boneftf.translation);
    memoryTools.readMemory(bones + part * 48 + 0x20, sizeof(ImVec3), &boneftf.scale3d);
    
    Ue4Matrix bonematrix = transformToMatrix(boneftf);
    
    return matrixToVector(matrixMulti(bonematrix, actormatrix));
}

//骨骼3d转换屏幕
bool getBone2d(MinimalViewInfo pov,ImVec2 screen, uintptr_t human, uintptr_t bones, int part,ImVec2 &buf) {
    //取世界坐标
    ImVec3 newmatrix = getBone(human, bones, part);
    //转屏幕坐标
    buf = worldToScreen(newmatrix, pov, screen);
    //范围
    return buf.x != 0 && buf.y != 0;
}
