//
//  CustomStrcut.h
//  Dolphins
//
//  Created by 明笙 on 2022/4/24.
//

#ifndef CustomStrcut_h
#define CustomStrcut_h

#include "imgui.h"

#include <string>

enum SystemStatus {
    //
    WaitingResponse,
    //系统错误
    SystemError,
    //需要更新
    NeedUpdate,
    //登录失败
    LoginFailure,
    //服务器校验失败
    CheckFailure,
    //状态正常
    TransmissionNormal,
};

enum MaterialType{
    Null = -1,
    Vehicle = 0,
    Airdrop = 1,
    FlareGun = 2,
    Sniper = 3,
    Rifle = 4,
    Missile = 5,
    Armor = 6,
    SniperParts = 7,
    RifleParts = 8,
    Drug = 9,
    Bullet = 10,
    Grip = 11,
    Sight = 12,
    Warning = 13,
    All = 14,
    WEP=15,
    MachineGun=16,
    Pistol=17,
    ShotGun=18
    
};


struct MainSwitch {
    bool playerStatus;
    bool materialStatus;
    bool aimbotStatus;
};


struct PlayerSwitch {
    //方框
    bool boxStatus;
    //骨骼
    bool boneStatus;
    //天线
    bool lineStatus;
    //信息
    bool infoStatus;
    //雷达
    bool radarStatus;
    //背敌
    bool backStatus;
    //手持贴图
    bool SCStatus;
    //手持文字
    bool SCWZStatus;
    //物资贴图
    bool WZStatus;
    //物资文字
    bool WZWZStatus;
    //经典
    bool jdStatus;
    //简洁
    bool jjStatus;
    //雷达大小
    float radarSize;
    //雷达坐标
    ImVec2 radarCoord;
};


struct AimbotController {
    //倒地不瞄
    bool fallNotAim;
    //自瞄启动类型
    int aimbotMode;
    //自瞄部位
    int aimbotParts;
    //自瞄半径
    float aimbotRadius;
    //
    bool showAimbotRadius;
    //自瞄强度
    float aimbotIntensity;
    
    float distance;
    
    bool smoke;
};

struct ModuleControl{
    bool menuStatus;
    
    int fps;
    //
    SystemStatus systemStatus;
    
    MainSwitch mainSwitch;
    
    PlayerSwitch playerSwitch;
    
    bool materialSwitch[All];
    
    AimbotController aimbotController;
};


struct BonesData {
    ImVec2 head;
    ImVec2 pit;
    ImVec2 pelvis;
    ImVec2 lcollar;
    ImVec2 rcollar;
    ImVec2 lelbow;
    ImVec2 relbow;
    ImVec2 lwrist;
    ImVec2 rwrist;
    ImVec2 lthigh;
    ImVec2 rthigh;
    ImVec2 lknee;
    ImVec2 rknee;
    ImVec2 lankle;
    ImVec2 rankle;
};

struct PlayerData {
    std::string name;
    ImVec2 screen;
    ImVec2 size;
    ImVec2 radar;
    float angle;
    int team;
    float hp;
    std::string weaponName;
    std::string statusName;
    int distance;
    int robot;
    int status;
    BonesData bonesData;
    bool visibility;
    
};


struct MaterialData {
    int type;
    int id;
    std::string name;
    int distance;
    ImVec2 screen;
};

struct StaticPlayerData {
    uintptr_t addr;
    uintptr_t coordAddr;
    std::string name;
    int team;
    int status;
    bool robot;
};

struct StaticMaterialData {
    std::string name;
    int type;
    int id;
    uintptr_t addr;
    uintptr_t coordAddr;
};

struct Ue4Transform {
    ImVec4 rotation;
    ImVec3 translation;
    ImVec3 scale3d;
};

struct Ue4Matrix {
    float matrix[4][4];
    
    float *operator[](int index) {
        return matrix[index];
    }
    
};

struct Ue4Rotator {
    float pitch;
    float yaw;
    float roll;
};

struct MinimalViewInfo {
    ImVec3 location;
    ImVec3 locationLocalSpace;
    Ue4Rotator rotation;
    float fov;
};

struct MaterialStruct {
    int type;
    int id;
    char name[64];
};

ImVec3 matrixToVector(Ue4Matrix matrix);

Ue4Matrix matrixMulti(Ue4Matrix m1, Ue4Matrix m2);

Ue4Matrix transformToMatrix(Ue4Transform transform);

Ue4Matrix rotatorToMatrix(ImVec3 rotation);

ImVec2 worldToScreen(ImVec3 worldLocation, MinimalViewInfo camViewInfo, ImVec2 screenCenter);
//换算角度 0-360
float getAngleDifference(float angle1, float angle2);
//正数负数互转
float change(float num);
//计算2D距离
float get2dDistance(ImVec2 self, ImVec2 object);
//计算3D距离
float get3dDistance(ImVec3 self, ImVec3 object, float divice);

//旋转指定角度2D坐标
ImVec2 rotateCoord(float angle, ImVec2 coord);
//计算3D坐标2d角度
float rotateAngle(ImVec3 selfCoord, ImVec3 targetCoord);
//计算3D坐标3D角度
ImVec2 rotateAngleView(ImVec3 selfCoord, ImVec3 targetCoord);
//判断物资是否被摄取
bool isRecycled(const char *name);
//是否为武器
MaterialStruct isWeapon(const char *name);
//是否为物资
MaterialStruct isMaterial(const char *name);
//是否为物资(盒子)
MaterialStruct isBoxMaterial(int box_goods_id);
#endif /* CustomStrcut_h */


