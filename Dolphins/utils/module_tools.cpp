//
//  module_tools.c
//  Dolphins
//
//  Created by XBK on 2022/4/25.
//

#include "module_tools.h"
#include <math.h>

#pragma mark - 坐标系转换
ImVec3 matrixToVector(Ue4Matrix matrix) {
    return ImVec3(matrix[3][0], matrix[3][1], matrix[3][2]);
}

Ue4Matrix matrixMulti(Ue4Matrix m1, Ue4Matrix m2) {
    Ue4Matrix matrix = Ue4Matrix();
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            for (int k = 0; k < 4; k++) {
                matrix[i][j] += m1[i][k] * m2[k][j];
            }
        }
    }
    return matrix;
}

Ue4Matrix transformToMatrix(Ue4Transform transform) {
    Ue4Matrix matrix;
    
    matrix[3][0] = transform.translation.x;
    matrix[3][1] = transform.translation.y;
    matrix[3][2] = transform.translation.z;
    
    float x2 = transform.rotation.x + transform.rotation.x;
    float y2 = transform.rotation.y + transform.rotation.y;
    float z2 = transform.rotation.z + transform.rotation.z;
    
    float xx2 = transform.rotation.x * x2;
    float yy2 = transform.rotation.y * y2;
    float zz2 = transform.rotation.z * z2;
    
    matrix[0][0] = (1.0f - (yy2 + zz2)) * transform.scale3d.x;
    matrix[1][1] = (1.0f - (xx2 + zz2)) * transform.scale3d.y;
    matrix[2][2] = (1.0f - (xx2 + yy2)) * transform.scale3d.z;
    
    float yz2 = transform.rotation.y * z2;
    float wx2 = transform.rotation.w * x2;
    matrix[2][1] = (yz2 - wx2) * transform.scale3d.z;
    matrix[1][2] = (yz2 + wx2) * transform.scale3d.y;
    
    float xy2 = transform.rotation.x * y2;
    float wz2 = transform.rotation.w * z2;
    matrix[1][0] = (xy2 - wz2) * transform.scale3d.y;
    matrix[0][1] = (xy2 + wz2) * transform.scale3d.x;
    
    float xz2 = transform.rotation.x * z2;
    float wy2 = transform.rotation.w * y2;
    matrix[2][0] = (xz2 + wy2) * transform.scale3d.z;
    matrix[0][2] = (xz2 - wy2) * transform.scale3d.x;
    
    matrix[0][3] = 0;
    matrix[1][3] = 0;
    matrix[2][3] = 0;
    matrix[3][3] = 1;
    
    return matrix;
}

Ue4Matrix rotatorToMatrix(Ue4Rotator rotation) {
    float radPitch = rotation.pitch * ((float) M_PI / 180.0f);
    float radYaw = rotation.yaw * ((float) M_PI / 180.0f);
    float radRoll = rotation.roll * ((float) M_PI / 180.0f);
    
    float SP = sinf(radPitch);
    float CP = cosf(radPitch);
    float SY = sinf(radYaw);
    float CY = cosf(radYaw);
    float SR = sinf(radRoll);
    float CR = cosf(radRoll);
    
    Ue4Matrix matrix;
    
    matrix[0][0] = (CP * CY);
    matrix[0][1] = (CP * SY);
    matrix[0][2] = (SP);
    matrix[0][3] = 0;
    
    matrix[1][0] = (SR * SP * CY - CR * SY);
    matrix[1][1] = (SR * SP * SY + CR * CY);
    matrix[1][2] = (-SR * CP);
    matrix[1][3] = 0;
    
    matrix[2][0] = (-(CR * SP * CY + SR * SY));
    matrix[2][1] = (CY * SR - CR * SP * SY);
    matrix[2][2] = (CR * CP);
    matrix[2][3] = 0;
    
    matrix[3][0] = 0;
    matrix[3][1] = 0;
    matrix[3][2] = 0;
    matrix[3][3] = 1;
    
    return matrix;
}

ImVec2 worldToScreen(ImVec3 worldLocation, MinimalViewInfo camViewInfo, ImVec2 screenCenter) {
    Ue4Matrix tempMatrix = rotatorToMatrix(camViewInfo.rotation);
    
    ImVec3 vAxisX(tempMatrix[0][0], tempMatrix[0][1], tempMatrix[0][2]);
    ImVec3 vAxisY(tempMatrix[1][0], tempMatrix[1][1], tempMatrix[1][2]);
    ImVec3 vAxisZ(tempMatrix[2][0], tempMatrix[2][1], tempMatrix[2][2]);
    
    ImVec3 vDelta = worldLocation - camViewInfo.location;
    
    ImVec3 vTransformed(ImVec3::Dot(vDelta, vAxisY), ImVec3::Dot(vDelta, vAxisZ), ImVec3::Dot(vDelta, vAxisX));
    
    if (vTransformed.z < 1.0f) {
        vTransformed.z = 1.0f;
    }
    ImVec2 screenCoord;
    screenCoord.x = (screenCenter.x + vTransformed.x * (screenCenter.x / tanf(camViewInfo.fov * ((float) M_PI / 360.0f))) / vTransformed.z);
    screenCoord.y = (screenCenter.y - vTransformed.y * (screenCenter.x / tanf(camViewInfo.fov * ((float) M_PI / 360.0f))) / vTransformed.z);
    return screenCoord;
}
//雷达
float getAngleDifference(float angle1, float angle2) {
    float diff = fmod(angle2 - angle1 + 180, 360) - 180;
    return diff < -180 ? diff + 360 : diff;
}

float change(float num) {
    if (num < 0) {
        return abs(num);
    } else if (num > 0) {
        return num - num * 2;
    }
    return num;
}

float get2dDistance(ImVec2 self, ImVec2 object) {
    float osx = self.x - object.x;
    float osy = self.y - object.y;
    
    return sqrt(osx * osx + osy * osy);
}

float get3dDistance(ImVec3 self, ImVec3 object, float divice) {
    ImVec3 xyz;
    xyz.x = self.x - object.x;
    xyz.y = self.y - object.y;
    xyz.z = self.z - object.z;
    return sqrt(pow(xyz.x, 2) + pow(xyz.y, 2) + pow(xyz.z, 2)) / divice;
}

ImVec2 rotateCoord(float angle, ImVec2 coord) {
    float s = sin(angle * M_PI / 180);
    float c = cos(angle * M_PI / 180);
    
    return {coord.x * c + coord.y * s, -coord.x * s + coord.y * c};
}

float rotateAngle(ImVec3 selfCoord, ImVec3 targetCoord) {
    float osx = targetCoord.x - selfCoord.x;
    float osy = targetCoord.y - selfCoord.y;
    return (float) (atan2(osy, osx) * 180 / M_PI);
}

ImVec2 rotateAngleView(ImVec3 selfCoord, ImVec3 targetCoord) {
    
    float osx = targetCoord.x - selfCoord.x;
    float osy = targetCoord.y - selfCoord.y;
    float osz = targetCoord.z - selfCoord.z;
    
    return {(float) (atan2(osy, osx) * 180 / M_PI), (float) (atan2(osz, sqrt(osx * osx + osy * osy)) * 180 / M_PI)};
}

bool isRecycled(const char *name) {
    return strstr(name, "ecycled") != 0;
}
//手持武器
MaterialStruct isWeapon(const char *name) {
    if (strstr(name, "Sniper_QBU") != 0) {
        return {Sniper, 0,  "[狙击枪]QBU" };
    } else if (strstr(name, "Sniper_SLR") != 0) {
        return {Sniper, 1, "[狙击枪]SLR"};
    } else if (strstr(name, "Sniper_SKS") != 0) {
        return {Sniper, 2, "[狙击枪]SKS"};
    } else if (strstr(name, "Sniper_Mini14") != 0) {
        return {Sniper, 3, "[狙击枪]Mini14"};
    } else if (strstr(name, "Sniper_M24") != 0) {
        return {Sniper, 4, "[狙击枪]M24"};
    } else if (strstr(name, "Sniper_Kar98k") != 0) {
        return {Sniper, 5, "[狙击枪]Kar98k"};
    } else if (strstr(name, "Sniper_AWM") != 0) {
        return {Sniper, 6, "[狙击枪]AWM"};
    } else if (strstr(name, "WEP_Mk14") != 0) {
        return {Sniper, 7, "[狙击枪]Mk14"};
    } else if (strstr(name, "Sniper_Mosin") != 0) {
        return {Sniper, 8, "[狙击枪]莫辛纳甘"};
    } else if (strstr(name, "Sniper_MK12") != 0) {
        return {Sniper, 9, "[狙击枪]MK12"};
    } else if (strstr(name, "Sniper_AMR") != 0) {
        return {Sniper, 10, "[狙击枪]AMR"};
    } else if (strstr(name, "Sniper_VSS") != 0) {
        return {Sniper, 10, "[狙击枪]VSS"};
    
    } else if (strstr(name, "Rifle_M762") != 0) {
        return {Rifle, 0, "[步枪]M762"};
    } else if (strstr(name, "Rifle_SCAR") != 0) {
        return {Rifle, 1, "[步枪]SCAR-L"};
    } else if (strstr(name, "Rifle_M416") != 0) {
        return {Rifle, 2, "[步枪]M416"};
    } else if (strstr(name, "Rifle_M16A4") != 0) {
        return {Rifle, 3, "[步枪]M16A4"};
    } else if (strstr(name, "Rifle_Mk47") != 0) {
        return {Rifle, 4, "[步枪]Mk47"};
    } else if (strstr(name, "Rifle_G36") != 0) {
        return {Rifle, 5, "[步枪]G36C"};
    } else if (strstr(name, "Rifle_QBZ") != 0) {
        return {Rifle, 6, "[步枪]QBZ"};
    } else if (strstr(name, "Rifle_Groza") != 0) {
        return {Rifle, 7, "[步枪]Groza"};
    } else if (strstr(name, "Rifle_AUG") != 0) {
        return {Rifle, 8, "[步枪]AUG"};
    } else if (strstr(name, "Rifle_AKM") != 0) {
        return {Rifle, 9, "[步枪]AKM"};
        
    } else if (strstr(name, "Other_DP28") != 0) {
        return {Rifle, 10, "[机枪]大盘鸡"};
    } else if (strstr(name, "Other_M249") != 0) {
        return {Rifle, 11, "[机枪]大菠萝"};
    } else if (strstr(name, "Other_MG3") != 0) {
        return {Rifle, 12, "[机枪]MG3"};
        
    } else if (strstr(name, "Grenade_Shoulei_Weapon_C") != 0) {
        return {Missile, 0, "[投掷物]手雷"};
    } else if (strstr(name, "Grenade_Smoke_Weapon_C") != 0) {
        return {Missile, 1, "[投掷物]烟雾弹"};
    } else if (strstr(name, "Grenade_Burn_Weapon_C") != 0) {
        return {Missile, 2, "[投掷物]燃烧瓶"};
    
    } else if (strstr(name, "WEP_Pan") != 0) {
        return {WEP, 0, "[近战]平底锅"};
    } else if (strstr(name, "WEP_Sickle") != 0) {
        return {WEP, 1, "[近战]镰刀"};
    } else if (strstr(name, "WEP_Machere_") != 0) {
        return {WEP, 2, "[近战]大砍刀"};
    } else if (strstr(name, "WEP_Cowbar") != 0) {
        return {WEP, 3, "[近战]撬棍"};
    
    } else if (strstr(name, "MachineGun_MP5K") != 0) {
        return {MachineGun, 0, "[冲锋枪]MP5K"};
    } else if (strstr(name, "MachineGun_P90") != 0) {
        return {MachineGun, 1, "[冲锋枪]P90"};
    } else if (strstr(name, "MachineGun_TommyGun") != 0) {
        return {MachineGun, 2, "[冲锋枪]TommyGun"};
    } else if (strstr(name, "MachineGun_UMP9") != 0) {
        return {MachineGun, 3, "[冲锋枪]UMP9"};
    } else if (strstr(name, "MachineGun_Uzi") != 0) {
        return {MachineGun, 4, "[冲锋枪]Uzi"};
    } else if (strstr(name, "MachineGun_Vector") != 0) {
        return {MachineGun, 5, "[冲锋枪]Vector"};
    } else if (strstr(name, "MachineGun_Bison") != 0) {
        return {MachineGun, 6, "[冲锋枪]Bison"};
    
    } else if (strstr(name, "ShotGun_S686") != 0) {
        return {ShotGun, 0, "[霰弹枪]S686"};
    } else if (strstr(name, "ShotGun_S1897") != 0) {
        return {ShotGun, 1, "[霰弹枪]S1897"};
    } else if (strstr(name, "ShotGun_S12K") != 0) {
        return {ShotGun, 2, "[霰弹枪]S12K"};
    } else if (strstr(name, "ShotGun_DBS") != 0) {
        return {ShotGun, 3, "[霰弹枪]DBS"};
    } else if (strstr(name, "ShotGun_SawedOff") != 0) {
        return {ShotGun, 4, "[霰弹枪]SawedOff"};
    
    
    } else if (strstr(name, "Pistol_P92") != 0) {
        return {Pistol, 0, "[手枪]P92"};
    } else if (strstr(name, "Pistol_P1911") != 0) {
        return {Pistol, 1, "[手枪]P1911"};
    } else if (strstr(name, "Pistol_R1895") != 0) {
        return {Pistol, 2, "[手枪]R1895"};
    } else if (strstr(name, "Pistol_P18C") != 0) {
        return {Pistol, 3, "[手枪]P18C"};
    } else if (strstr(name, "Pistol_R45") != 0) {
        return {Pistol, 4, "[手枪]R45"};
    }
    
    return {-1, -1, "NULL"};
}
//地面显示
MaterialStruct isMaterial(const char *name) {
    if (strstr(name, "Motorcycle_") != 0) {
        return {Vehicle, 0, "摩托车"};
    } else if (strstr(name, "MotorcycleCart") != 0) {
        return {Vehicle, 1, "三轮摩托"};
    } else if (strstr(name, "Scooter") != 0) {
        return {Vehicle, 2, "小绵羊"};// 小绵羊车
    } else if (strstr(name, "Buggy") != 0) {
        return {Vehicle, 3, "蹦蹦"};// 蹦蹦
    } else if (strstr(name, "Mirado") != 0) {
        return {Vehicle, 4, "跑车"};// 玛萨拉蒂
    } else if (strstr(name, "Dacia") != 0) {
        return {Vehicle, 5, "轿车"};// 轿车
 //   } else if (strstr(name, "PickUp") != 0 && strstr(name, "Armor") == 0 && strstr(name, "List") == 0 && strstr(name, "Helmet") == 0 && strstr(name, "Bag") == 0) {
//        return {Vehicle, 6, "皮卡车"};// 皮卡车
    } else if (strstr(name, "UAZ") != 0) {
        return {Vehicle, 7, "吉普"};// 吉普
    } else if (strstr(name, "PG117") != 0) {
        return {Vehicle, 8, "大船"};// 快艇
    } else if (strstr(name, "AquaRail") != 0) {
        return {Vehicle, 9, "摩托艇"};// 冲锋艇
    } else if (strstr(name, "MiniBus") != 0) {
        return {Vehicle, 10, "宝宝巴士"};// 面包车
    } else if (strstr(name, "BRDM") != 0) {
        return {Vehicle, 11, "装甲车"};// 两栖装甲车
    } else if (strstr(name, "LadaNiva") != 0) {
        return {Vehicle, 12, "吉普车"};// 拉达尼瓦
    } else if (strstr(name, "Snowbike") != 0) {
        return {Vehicle, 13, "雪地摩托"};// 轻型雪地车
    } else if (strstr(name, "Snowmobile") != 0) {
        return {Vehicle, 14, "雪地重型摩托"};// 重型雪地车
    } else if (strstr(name, "Rony") != 0) {
        return {Vehicle, 15, "皮卡"};// 小货车
    } else if (strstr(name, "CoupeRB_1") != 0) {
        return {Vehicle, 16, "CoupeRB"};// 小货车
        
    } else if (strstr(name, "PickUpList") != 0) {
        return {Airdrop, 0, "[盒子]"};
    } else if (strstr(name, "AirDropList") != 0) {
        return {Airdrop, 1, "[空投]"};
    } else if (strstr(name, "DeadInventoryBox") != 0) {
        return {Airdrop, 2, "盒子"};
    } else if (strstr(name, "AirDropBox") != 0) {
        return {Airdrop, 3, "空投"};
        
    } else if (strstr(name, "Pistol_Flaregun") != 0) {
        return {FlareGun, 0, "信号枪"};
        
    } else if (strstr(name, "Sniper_QBU") != 0) {
        return {Sniper, 0, "QBU"};
    } else if (strstr(name, "Sniper_SLR") != 0) {
        return {Sniper, 1, "SLR"};
    } else if (strstr(name, "Sniper_SKS") != 0) {
        return {Sniper, 2, "SKS"};
    } else if (strstr(name, "Sniper_Mini14") != 0) {
        return {Sniper, 3, "Mini14"};
    } else if (strstr(name, "Sniper_M24") != 0) {
        return {Sniper, 4, "M24"};
    } else if (strstr(name, "Sniper_Kar98k") != 0) {
        return {Sniper, 5, "Kar98k"};
    } else if (strstr(name, "Sniper_AWM") != 0) {
        return {Sniper, 6, "AWM"};
    } else if (strstr(name, "Sniper_Mk14") != 0) {
        return {Sniper, 7, "Mk14"};
    } else if (strstr(name, "Sniper_Mosin") != 0) {
        return {Sniper, 8, "莫辛纳甘"};
    } else if (strstr(name, "Sniper_MK12") != 0) {
        return {Sniper, 9, "MK12"};
    } else if (strstr(name, "Sniper_AMR") != 0) {
        return {Sniper, 10, "AMR"};
        
    } else if (strstr(name, "Rifle_M762") != 0) {
        return {Rifle, 0, "M762"};
    } else if (strstr(name, "Rifle_SCAR") != 0) {
        return {Rifle, 1, "SCAR-L"};
    } else if (strstr(name, "Rifle_M416") != 0) {
        return {Rifle, 2, "M416"};
    } else if (strstr(name, "Rifle_M16A4") != 0) {
        return {Rifle, 3, "M16A4"};
    } else if (strstr(name, "Rifle_Mk47") != 0) {
        return {Rifle, 4, "Mk47"};
    } else if (strstr(name, "Rifle_G36") != 0) {
        return {Rifle, 5, "G36C"};
    } else if (strstr(name, "Rifle_QBZ") != 0) {
        return {Rifle, 6, "QBZ"};
    } else if (strstr(name, "Rifle_Groza") != 0) {
        return {Rifle, 7, "Groza"};
    } else if (strstr(name, "Rifle_AUG") != 0) {
        return {Rifle, 8, "AUG"};
    } else if (strstr(name, "Rifle_AKM") != 0) {
        return {Rifle, 9, "AKM"};
    } else if (strstr(name, "Other_DP28") != 0) {
        return {Rifle, 10, "大盘鸡"};
    } else if (strstr(name, "Other_M249") != 0) {
        return {Rifle, 11, "大菠萝"};
    } else if (strstr(name, "Other_MG3") != 0) {
        return {Rifle, 12, "MG3"};
        
    } else if (strstr(name, "Grenade_Shoulei_Weapon_") != 0) {
        return {Missile, 0, "手雷"};
    } else if (strstr(name, "Grenade_Smoke_Weapon_") != 0) {
        return {Missile, 1, "烟雾弹"};
    } else if (strstr(name, "Grenade_Burn_Weapon_") != 0) {
        return {Missile, 2, "燃烧瓶"};
        
//    } else if (strstr(name, "Armor_Lv2") != 0) {
//        return {Armor, 0, "[防具]二级甲"};
    } else if (strstr(name, "Armor_Lv3") != 0) {
        return {Armor, 1, "三级甲"};
//    } else if (strstr(name, "Bag_Lv2") != 0) {
//        return {Armor, 2, "[背包]二级包"};
    } else if (strstr(name, "Bag_Lv3") != 0) {
        return {Armor, 3, "三级包"};
//    } else if (strstr(name, "Helmet_Lv2") != 0) {
//        return {Armor, 4, "[防具]二级头"};
    } else if (strstr(name, "Helmet_Lv3") != 0) {
        return {Armor, 5, "三级头"};
        
    } else if (strstr(name, "QT_Sniper") != 0) {
        return {SniperParts, 0, "托腮板"};
    } else if (strstr(name, "ZDD_Sniper") != 0) {
        return {SniperParts, 1, "子弹袋"};
    } else if (strstr(name, "Sniper_FlashHider") != 0) {
        return {SniperParts, 2, "消焰器"};
    } else if (strstr(name, "Sniper_Compensator") != 0) {
        return {SniperParts, 3, "枪口补偿"};
    } else if (strstr(name, "Sniper_Suppressor") != 0) {
        return {SniperParts, 4, "消音器"};
    } else if (strstr(name, "Sniper_EQ") != 0) {
        return {SniperParts, 5, "快速扩容"};
    } else if (strstr(name, "Sniper_E") != 0) {
        return {SniperParts, 6, "扩容"};
        
    } else if (strstr(name, "QT_A") != 0) {
        return {RifleParts, 0, "战术枪托"};
    } else if (strstr(name, "Large_FlashHider") != 0) {
        return {RifleParts, 1, "消焰器"};
    } else if (strstr(name, "Large_Compensator") != 0) {
        return {RifleParts, 2, "枪口补偿"};
    } else if (strstr(name, "Large_Suppressor") != 0) {
        return {RifleParts, 3, "消音器"};
    } else if (strstr(name, "Large_EQ") != 0) {
        return {RifleParts, 4, "快速扩容"};
    } else if (strstr(name, "Large_E") != 0) {
        return {RifleParts, 5, "扩容"};
        
    } else if (strstr(name, "Pills") != 0) {
        return {Drug, 0, "止痛药"};
    } else if (strstr(name, "Injection") != 0) {
        return {Drug, 1, "肾上腺素"};
    } else if (strstr(name, "Drink") != 0) {
        return {Drug, 2, "饮料"};
    } else if (strstr(name, "Firstaid") != 0) {
        return {Drug, 3, "急救包"};
    } else if (strstr(name, "FirstAidbox") != 0) {
        return {Drug, 4, "医疗箱"};
    } else if (strstr(name, "GasCanBattery_Destructible_") != 0) {
        return {Drug, 5, "油桶"};
    
    } else if (strstr(name, "Ammo_556mm") != 0) {
        return {Bullet, 0, "5.56mm"};
    } else if (strstr(name, "Ammo_762mm") != 0) {
        return {Bullet, 1, "7.62mm"};
    } else if (strstr(name, "Ammo_300Magnum") != 0) {
        return {Bullet, 2, "马格南"};
    } else if (strstr(name, "Ammo_50BMG") != 0) {
        return {Bullet, 3, "马格南"};
        
    } else if (strstr(name, "WB_ThumbGrip") != 0) {
        return {Grip, 0, "拇指握把"};
    } else if (strstr(name, "WB_LightGrip") != 0) {
        return {Grip, 1, "轻型握把"};
    } else if (strstr(name, "WB_Vertical") != 0) {
        return {Grip, 2, "垂直握把"};
    } else if (strstr(name, "WB_Angled") != 0) {
        return {Grip, 3, "直角前握把"};
    } else if (strstr(name, "WB_HalfGrip") != 0) {
        return {Grip, 4, "半截式握把"};
    } else if (strstr(name, "WB_Lasersight") != 0) {
        return {Grip, 5, "激光握把"};
        
    } else if (strstr(name, "MZJ_HD") != 0) {
        return {Sight, 0, "红点"};
    } else if (strstr(name, "MZJ_QX") != 0) {
        return {Sight, 1, "全息"};
    } else if (strstr(name, "MZJ_3X") != 0) {
        return {Sight, 2, "3X"};
    } else if (strstr(name, "MZJ_4X") != 0) {
        return {Sight, 3, "4X"};
    } else if (strstr(name, "MZJ_6X") != 0) {
        return {Sight, 4, "6X"};
    } else if (strstr(name, "MZJ_8X") != 0) {
        return {Sight, 5, "8X"};
   
    
    } else if (strstr(name, "ProjFire__") != 0) {
        return {Warning, 0, "[预警]闪光灯"};
    } else if (strstr(name, "ProjBurn_") != 0) {
        return {Warning, 1, "[预警]燃烧瓶"};
    } else if (strstr(name, "ProjSmoke_") != 0) {
        return {Warning, 2, "[预警]烟雾弹"};
    } else if (strstr(name, "ProjGrenade_") != 0) {
        return {Warning, 3, "[预警]小心手雷"};
    } else if (strstr(name, "AirAttackBomb") != 0) {
        return {Warning, 4, "[轰炸预警]小心轰炸区"};
   
    }
    return {-1, -1, "NULL"};
}
//盒子内
MaterialStruct isBoxMaterial(int box_goods_id) {
    if (box_goods_id == 601006) {
        return {Drug, 4, "[药]医疗箱"};
    } else if (box_goods_id == 601005) {
        return {Drug, 3, "[药]急救包"};
    } else if (box_goods_id == 601001) {
        return {Drug, 2, "[药]饮料"};
    } else if (box_goods_id == 601002) {
        return {Drug, 1, "[药]肾上腺素"};
    } else if (box_goods_id == 601003) {
        return {Drug, 0, "[药]止痛药"};
        
    } else if (box_goods_id == 503002) {
        return {Armor, 0, "[防]二级甲"};
    } else if (box_goods_id == 503003) {
        return {Armor, 1, "[防]三级甲"};
    } else if (box_goods_id == 501002) {
        return {Armor, 2, "[包]二级包"};
    } else if (box_goods_id == 501006) {
        return {Armor, 3, "[包]三级包"};
    } else if (box_goods_id == 502002) {
        return {Armor, 4, "[头]二级头"};
    } else if (box_goods_id == 502003) {
        return {Armor, 5, "[头]三级头"};
        
    } else if (box_goods_id == 105001) {
        return {Sniper, 0, "[狙]QBU"};
    } else if (box_goods_id == 103009) {
        return {Sniper, 1, "[狙]SLR"};
    } else if (box_goods_id == 103004) {
        return {Sniper, 2, "[狙]SKS"};
    } else if (box_goods_id == 103006) {
        return {Sniper, 3, "[狙]Mini14"};
    } else if (box_goods_id == 103002) {
        return {Sniper, 4, "[狙]M24"};
    } else if (box_goods_id == 103001) {
        return {Sniper, 5, "[狙]Kar98k"};
    } else if (box_goods_id == 103003) {
        return {Sniper, 6, "[狙]AWM"};
    } else if (box_goods_id == 103002) {
        return {Sniper, 7, "[狙]Mk14"};
    } else if (box_goods_id == 103011) {
        return {Sniper, 9, "[狙]莫辛纳甘"};
    } else if (box_goods_id == 103100) {
        return {Sniper, 10, "[狙]MK12"};
    } else if (box_goods_id == 103012) {
        return {Sniper, 11, "[狙]AMR"};
        
    } else if (box_goods_id == 101008) {
        return {Rifle, 0, "[枪]M762"};
    } else if (box_goods_id == 101003) {
        return {Rifle, 1, "[枪]SCAR-L"};
    } else if (box_goods_id == 101004) {
        return {Rifle, 2, "[枪]M416"};
    } else if (box_goods_id == 101002) {
        return {Rifle, 3, "[枪]M16A4"};
    } else if (box_goods_id == 101009) {
        return {Rifle, 4, "[枪]Mk47"};
    } else if (box_goods_id == 101010) {
        return {Rifle, 5, "[枪]G36C"};
    } else if (box_goods_id == 101007) {
        return {Rifle, 6, "[枪]QBZ"};
    } else if (box_goods_id == 101005) {
        return {Rifle, 7, "[枪]Groza"};
    } else if (box_goods_id == 101006) {
        return {Rifle, 8, "[枪]AUG"};
    } else if (box_goods_id == 101001) {
        return {Rifle, 9, "[枪]AKM"};
        
    } else if (box_goods_id == 105002) {
        return {Rifle, 10, "[机]大盘鸡"};
    } else if (box_goods_id == 105001) {
        return {Rifle, 11, "[机]大菠萝"};
    } else if (box_goods_id == 105010) {
        return {Rifle, 12, "[机]MG3"};
        
    } else if (box_goods_id == 303001) {
        return {Bullet, 0, "[弹]5.56mm"};
    } else if (box_goods_id == 302001) {
        return {Bullet, 1, "[弹]7.62mm"};
    } else if (box_goods_id == 306001) {
        return {Bullet, 2, "[弹]马格南"};
    } else if (box_goods_id == 308001) {
        return {Bullet, 4, "[弹]信号弹"};
        
    } else if (box_goods_id == 203001) {
        return {Sight, 0, "[镜]红点"};
    } else if (box_goods_id == 203002) {
        return {Sight, 1, "[镜]全息"};
    } else if (box_goods_id == 203014) {
        return {Sight, 2, "[镜]3X"};
    } else if (box_goods_id == 203004) {
        return {Sight, 3, "[镜]4X"};
    } else if (box_goods_id == 203015) {
        return {Sight, 4, "[镜]6X"};
    } else if (box_goods_id == 203005) {
        return {Sight, 5, "[镜]8X"};
        
    } else if (box_goods_id == 205003) {
        return {SniperParts, 0, "[狙配件]托腮板"};
    } else if (box_goods_id == 204014) {
        return {SniperParts, 1, "[狙配件]子弹袋"};
    } else if (box_goods_id == 204010) {
        return {SniperParts, 1, "[狙配件]子弹袋"};
    } else if (box_goods_id == 201005) {
        return {SniperParts, 2, "[狙配件]消焰器"};
    } else if (box_goods_id == 201003) {
        return {SniperParts, 3, "[狙配件]枪口补偿"};
    } else if (box_goods_id == 201007) {
        return {SniperParts, 4, "[狙配件]消音器"};
    } else if (box_goods_id == 204009) {
        return {SniperParts, 5, "[狙配件]快速扩容"};
    } else if (box_goods_id == 204007) {
        return {SniperParts, 6, "[狙配件]扩容"};
        
    } else if (box_goods_id == 202004) {
        return {Grip, 0, "[握]拇指握把"};
    }/*else if (box_goods_id == 000000) {
      return {Grip, 1, "[握把]轻型握把"};
      }*/ else if (box_goods_id == 202001) {
          return {Grip, 2, "[握]垂直握把"};
      }/*else if (box_goods_id == 000000) {
        return {Grip, 3, "[握把]直角前握把"};
        }*/else if (box_goods_id == 202005) {
            return {Grip, 4, "[握]半截式握把"};
            
        } else if (box_goods_id == 205002) {
            return {RifleParts, 0, "[配件]战术枪托"};
        } else if (box_goods_id == 201010) {
            return {RifleParts, 1, "[配件]消焰器"};
        } else if (box_goods_id == 201009) {
            return {RifleParts, 2, "[配件]枪口补偿"};
        } else if (box_goods_id == 201011) {
            return {RifleParts, 3, "[配件]消音器"};
        } else if (box_goods_id == 204013) {
            return {RifleParts, 4, "[配件]快速扩容"};
        } else if (box_goods_id == 204011) {
            return {RifleParts, 5, "[配件]扩容"};
            
        } else if (box_goods_id == 602004) {
            return {Missile, 0, "[投]手雷"};
        } else if (box_goods_id == 602002) {
            return {Missile, 1, "[投]烟雾弹"};
        } else if (box_goods_id == 602003) {
            return {Missile, 2, "[投]燃烧瓶"};
        }
    return {-1, -1, "[未知]"};
}
