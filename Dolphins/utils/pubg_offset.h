//
// Created by XBK on 2022/1/16.
//
namespace PubgOffset {
    uintptr_t GameNameOffset = 0x109D78308;

    uintptr_t GameMatrixOffset[3] = {0x109941418, 0x98, 0x750};//?
    namespace GameMatrixParam{
        int MatrixCoordOffset = 0x10;
        int FloatValueOffset = 0x2B8;   
    }

    uintptr_t GameWorldOffset = 0x10A0E8D38;//Gworld
    int PlayerControllerOffset[3] = {0x98, 0x78, 0x30};//*,*,PlayerController
    namespace PlayerControllerParam {
        int SelfOffset = 0x2328;//本人指针 STExtraBaseCharacter* STExtraBaseCharacter;
        int MouseOffset = 0x540;//鼠标
        int CameraManagerOffset = 0x5A0;//playerCameraManager->PlayerCameraManager* PlayerCameraManager
    namespace CameraManagerParam{
            int PovOffset = 0x1120 + 0x10;//delegate OnPlayerContollerTouchBegin;/
        }
        namespace ControllerFunction {
            int LineOfSightToOffset = 0x818;//StaticMeshComponent* SurfaceEffectMesh;
        }
    }

    int ULevelOffset = 0x90;//uLevel
    namespace ULevelParam {
        int ObjectArrayOffset = 0xA0;//数组
        int ObjectCountOffset = 0xA8;//成员数量
    }

    namespace ObjectParam {
        int ClassIdOffset = 0x18;//类型ID
        int ClassNameOffset = 0xE;

        namespace PlayerFunction {
            int AddControllerYawInputOffset = 0x8F0;//ExitShovelingTPPFovChangeSpeed;
            int AddControllerRollInputOffset = 0x8E8;//ShovelingTPPFovVaule;
            int AddControllerPitchInputOffset = 0x8F8;//ShovelingLegStartFollowBodyMinAngle;
        }

        int TeamMateOffset = 0x530;//自己队伍
        namespace TeamMateParam{
            int TeamNumberOffset = 0x1C;//队伍内编号
        }
        int angleOffset = 0x118;//敌人视角角度
        int StatusOffset = 0xED8;//人物状态PawnStateRepSyncData PawnStateRepSyncData;
        int TeamOffset = 0x9F8;//人物队伍ID
        int NameOffset = 0x988;//人物名字
        int RobotOffset = 0xA14;//人物人机判断
        int HpOffset = 0xCE8;//人物血量
        int MoveCoordOffset = 0x2018;//人物移动坐标//STCharacterMovementComponent* STCharacterMovement;

        int RideVehicleOffset = 0x128;//0x128;//乘坐人物载具
        int DriveVehicleOffset = 0xB90;//0xB90;//驾驶人物载具

        int MeshOffset = 0x598;//人物骨骼列阵
        namespace MeshParam{
            int HumanOffset = 0x1B0;//人物骨骼基矩阵
            int BonesOffset = 0x6D8;//人物骨骼
        }

        int OpenFireOffset = 0x1670;//开火
        int OpenTheSightOffset = 0xF70;//开镜

        int WeaponOneOffset = 0x26D8;//人物手持武器
        namespace WeaponParam{
            int MasterOffset = 0xB0;//枪械主人
            int ShootModeOffset = 0xEF4;//武器射击模式
            int WeaponAttrOffset = 0x10F0;//武器属性
            namespace WeaponAttrParam{
                int BulletSpeedOffset = 0xC4C;//武器子弹速度
                int RecoilOffset = 0x1100;//武器后坐力
            }
        }

        int GoodsListOffset = 0x968;//盒子物资 PickUpItemData[] PickUpDataList;/
        namespace GoodsListParam {
            int DataBase = 0x38;
        }

        int CoordOffset = 0x268;//对象坐标
        namespace CoordParam {
            int HeightOffset = 0x184;//对象高度 可用性未知
            int CoordOffset = 0x1C0;//对象坐标 xyzCurveVector* CurveForRootScale;
        }
    }
}
