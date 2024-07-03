//
//  Dolphins.h
//  Dolphins
//
//  Created by XBK on 2022/4/24.
//
#include "imgui.h"

//静态数据线程
void *readStaticData(void *);

//获取帧数据
void readFrameData(ImVec2 screenSize,std::vector<PlayerData> &playerDataList, std::vector<MaterialData> &materialDataList);

//自瞄
void *silenceAimbot(void *);
    
//掩体判断
bool isCoordVisibility(ImVec3 coord);
//是否在烟雾内
bool isOnSmoke(ImVec3 coord);

//取人物名字
char* getPlayerName(uintptr_t addr);

//取对象类型名
char* getClassName(int classId);
char* statusName(int statusId);
//取骨骼点坐标
ImVec3 getBone(uintptr_t human, uintptr_t bones, int part);

//取骨骼点坐标(屏幕)
bool getBone2d(MinimalViewInfo pov,ImVec2 screen, uintptr_t human, uintptr_t bones, int part,ImVec2 &buf);
