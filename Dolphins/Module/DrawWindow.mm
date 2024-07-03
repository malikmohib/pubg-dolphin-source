//
//  DrawWindow.m
//  Dolphins
//
//  Created by XBK on 2022/4/24.
//
#include "module_tools.h"
#import "DrawWindow.h"
#include "image_base64.h"
#import "OverlayView.h"
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width
@implementation DrawWindow
ImDrawList *imDrawList;

CGSize screenSize;

std::vector<PlayerData> playerDataList;
std::vector<MaterialData> materialDataList;
int xWidth =50;
int xtWidth =10;
int hpWidth = 50;
int hpHeight = 8;
int scWidth = 220;
int scHeight = 110;
int qtWidth = 220;
int qtHeight = 50;

id<MTLTexture> leizhaTexture;
id<MTLTexture> hongzhaTexture;
id<MTLTexture> shouleiTexture;
id<MTLTexture> sldTexture;
id<MTLTexture> ywdTexture;
id<MTLTexture> rspTexture;

id<MTLTexture> countTexture;
id<MTLTexture> count1Texture;
id<MTLTexture> count2Texture;
id<MTLTexture> count3Texture;
id<MTLTexture> count4Texture;
id<MTLTexture> count5Texture;
id<MTLTexture> quanTexture;
id<MTLTexture> playerTexture;
id<MTLTexture> robotTexture;

id<MTLTexture> M416Texture;
id<MTLTexture> M16Texture;
id<MTLTexture> GrozaTexture;
id<MTLTexture> AkmTexture;
id<MTLTexture> SCARTexture;
id<MTLTexture> MK47Texture;
id<MTLTexture> AUGTexture;
id<MTLTexture> M762Texture;
id<MTLTexture> QBZTexture;
id<MTLTexture> leiTexture;
id<MTLTexture> huoTexture;
id<MTLTexture> yanTexture;
id<MTLTexture> shanTexture;
id<MTLTexture> R1895Texture;
id<MTLTexture> P92Texture;
id<MTLTexture> P1911Texture;
id<MTLTexture> P18CTexture;
id<MTLTexture> R45Texture;
id<MTLTexture> SKSTexture;
id<MTLTexture> MINITexture;
id<MTLTexture> MK14Texture;
id<MTLTexture> VSSTexture;
id<MTLTexture> QBUTexture;
id<MTLTexture> SLRTexture;
id<MTLTexture> AWMTexture;
id<MTLTexture> M24Texture;
id<MTLTexture> K98Texture;
id<MTLTexture> MOTexture;
id<MTLTexture> LIANTexture;
id<MTLTexture> GUNTexture;
id<MTLTexture> DAOTexture;
id<MTLTexture> GUOTexture;
id<MTLTexture> UZITexture;
id<MTLTexture> TANGTexture;
id<MTLTexture> VKTTexture;
id<MTLTexture> MP5KTexture;
id<MTLTexture> UMP9Texture;
id<MTLTexture> YNTexture;
id<MTLTexture> DP28Texture;
id<MTLTexture> MG3Texture;
id<MTLTexture> M249Texture;
id<MTLTexture> DBSTexture;
id<MTLTexture> S686Texture;
id<MTLTexture> S12KTexture;

id<MTLTexture> JPTexture;
id<MTLTexture> BBTexture;
id<MTLTexture> jcTexture;
id<MTLTexture> mttTexture;
id<MTLTexture> mtTexture;
id<MTLTexture> myTexture;
id<MTLTexture> R8Texture;
id<MTLTexture> mt3Texture;

id<MTLTexture> m416Texture;
id<MTLTexture> akmTexture;
id<MTLTexture> augTexture;
id<MTLTexture> grozaTexture;
id<MTLTexture> m16Texture;
id<MTLTexture> m24Texture;
id<MTLTexture> m249Texture;
id<MTLTexture> m762Texture;
id<MTLTexture> mg3Texture;
id<MTLTexture> miniTexture;
id<MTLTexture> mk14Texture;
id<MTLTexture> mk47Texture;
id<MTLTexture> scarTexture;
id<MTLTexture> slrTexture;
id<MTLTexture> awmTexture;
id<MTLTexture> dp28Texture;
id<MTLTexture> k98Texture;
id<MTLTexture> vssTexture;
id<MTLTexture> sksTexture;
id<MTLTexture> hzTexture;

id<MTLTexture> ylTexture;
id<MTLTexture> jjbTexture;
id<MTLTexture> ztyTexture;
id<MTLTexture> ylxTexture;
id<MTLTexture> zhenTexture;

id<MTLTexture> b4Texture;
id<MTLTexture> b3Texture;
id<MTLTexture> b6Texture;
id<MTLTexture> b8Texture;

id<MTLTexture> ktTexture;
id<MTLTexture> t3Texture;
id<MTLTexture> j3Texture;
id<MTLTexture> bb3Texture;

id<MTLTexture> tleiTexture;
id<MTLTexture> tyanTexture;
id<MTLTexture> thuoTexture;

- (instancetype)initWithFrame:(ModuleControl*)control {
    self = [super init];
    
    self.moduleControl = control;
    
    screenSize = [UIScreen mainScreen].bounds.size;
    screenSize.width *= [UIScreen mainScreen].nativeScale;
    screenSize.height *= [UIScreen mainScreen].nativeScale;
    
    return self;
}

-(void)drawDrawWindow {
    ImGui::SetNextWindowSize(ImVec2(screenSize.width,screenSize.height));
    ImGui::SetNextWindowPos(ImVec2(0, 0));
    ImGui::Begin("alpha", nullptr, ImGuiWindowFlags_NoBackground | ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoInputs | ImGuiWindowFlags_NoMove);
    
    imDrawList = ImGui::GetWindowDrawList();
    
    //拉取一帧的数
    readFrameData(ImVec2(screenSize.width / 2,screenSize.height / 2),playerDataList, materialDataList);
    for (MaterialData materialData:materialDataList) {
            //判断是否在屏幕内
        if (self.moduleControl->playerSwitch.WZWZStatus) {
            if (materialData.name=="[预警]小心手雷") {//警告贴图
                imDrawList->AddImage((__bridge ImTextureID) leizhaTexture, ImVec2(screenSize.width / 2 - leizhaTexture.width / 2, 230), ImVec2(screenSize.width / 2 + leizhaTexture.width / 2, 230 + leizhaTexture.height), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
            }
            if (materialData.name=="[轰炸预警]小心轰炸区") {
                imDrawList->AddImage((__bridge ImTextureID) hongzhaTexture, ImVec2(screenSize.width / 2 - hongzhaTexture.width / 2, 180), ImVec2(screenSize.width / 2 + hongzhaTexture.width / 2, 180 + hongzhaTexture.height), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
            }
            if (materialData.name=="[预警]小心手雷") {
                imDrawList->AddImage((__bridge ImTextureID) sldTexture, ImVec2(materialData.screen.x+190 - qtWidth+1, materialData.screen.y-5 -  qtHeight+1), ImVec2(materialData.screen.x+190 - qtWidth+1 + qtHeight-2 , materialData.screen.y-5 - qtHeight + qtHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
            }
            if (materialData.name=="[预警]烟雾弹") {
                imDrawList->AddImage((__bridge ImTextureID) ywdTexture, ImVec2(materialData.screen.x+190 - qtWidth+1, materialData.screen.y-5 -  qtHeight+1), ImVec2(materialData.screen.x+190 - qtWidth+1 + qtHeight-2 , materialData.screen.y-5 - qtHeight + qtHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
            }
            if (materialData.name=="[预警]燃烧瓶") {
                imDrawList->AddImage((__bridge ImTextureID) rspTexture, ImVec2(materialData.screen.x+190 - qtWidth+1, materialData.screen.y-5 -  qtHeight+1), ImVec2(materialData.screen.x+190 - qtWidth+1 + qtHeight-2 , materialData.screen.y-5 - qtHeight + qtHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
            }
            
            //物品文字
            if (materialData.distance != -100){
                //载具
            if (materialData.name=="摩托车") {
                std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
                imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
             }
            if (materialData.name=="三轮摩托") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
               imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="小绵羊") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
               imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="蹦蹦") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
               imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="跑车") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="轿车") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="吉普") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="大船") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="摩托艇") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="宝宝巴士") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="装甲车") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="吉普车") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="雪地摩托") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="雪地重型摩托") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="皮卡") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            if (materialData.name=="CoupeRB") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 206, 209), 21, str.c_str());
            }
            //空投盒子
            if (materialData.name=="[盒子]") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 255, 0), 21, str.c_str());
            }
            if (materialData.name=="盒子") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 255, 0), 21, str.c_str());
            }
            if (materialData.name=="[空投]") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 20, 147), 21, str.c_str());
            }
            if (materialData.name=="空投") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 20, 147), 21, str.c_str());
            }
            if (materialData.name=="信号枪") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 20, 147), 21, str.c_str());
            }
            //狙击枪
            if (materialData.name=="QBU") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="SLR") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="SKS") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="Mini14") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="M24") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="Kar98k") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="Mk14") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="莫辛纳甘") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="MK12") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="AMR") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="AWM") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            //步枪
            if (materialData.name=="M762") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="SCAR-L") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="M416") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="M16A4") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="Mk47") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="G36C") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="QBZ") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="Groza") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="AUG") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="AKM") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="大盘鸡") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="大菠萝") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="MG3") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="手雷") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 127, 80), 21, str.c_str());
            }
            if (materialData.name=="烟雾弹") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 127, 80), 21, str.c_str());
            }
            if (materialData.name=="燃烧瓶") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 127, 80), 21, str.c_str());
            }
            if (materialData.name=="三级甲") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="三级包") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="三级头") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="止痛药") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
            }
            if (materialData.name=="肾上腺素") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
            }
            if (materialData.name=="饮料") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
            }
            if (materialData.name=="急救包") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
            }
            if (materialData.name=="医疗箱") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
            }
            if (materialData.name=="油桶") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
            }
            if (materialData.name=="红点") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
               imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="全息") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="3X") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="4X") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="6X") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="8X") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="[预警]燃烧瓶") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(178, 34, 34), 21, str.c_str());
            }
            if (materialData.name=="[预警]烟雾弹") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(178, 34, 34), 21, str.c_str());
            }
            if (materialData.name=="[预警]小心手雷") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(178, 34, 34), 21, str.c_str());
            }
            if (materialData.name=="[轰炸预警]小心轰炸区") {
               std::string str =  "["+ materialData.name +":" + std::to_string(materialData.distance) + "M]";
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(178, 34, 34), 21, str.c_str());
            }
            } else {
                if (materialData.name=="[药]止痛药") {
                   std::string str = materialData.name;
                    imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
                   imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
                }
                if (materialData.name=="[药]肾上腺素") {
                   std::string str = materialData.name;
                    imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
                   imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
                }
                if (materialData.name=="[药]饮料") {
                   std::string str = materialData.name;
                    imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
                   imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
                }
                if (materialData.name=="[药]急救包") {
                   std::string str = materialData.name;
                    imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
                   imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
                }
                if (materialData.name=="[药]医疗箱") {
                   std::string str = materialData.name;
                    imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
                   imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 210, 0), 21, str.c_str());
                }
            if (materialData.name=="[防]三级甲") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[包]三级包") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[头]三级头") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[防]二级甲") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[包]二级包") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[头]二级头") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            
            if (materialData.name=="[狙]QBU") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]SLR") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]SKS") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]Mini14") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]M24") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]Kar98k") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]Mk14") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]莫辛纳甘") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]MK12") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]AMR") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[狙]AWM") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 0, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]M762") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]SCAR-L") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]M416") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]M16A4") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]Mk47") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]G36C") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]QBZ") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]Groza") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]AUG") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[枪]AKM") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[机]大盘鸡") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[机]大菠萝") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[机]MG3") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 69, 0), 21, str.c_str());
            }
            if (materialData.name=="[弹]5.56mm") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 255, 0), 21, str.c_str());
            }
            if (materialData.name=="[弹]7.62mm") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 255, 0), 21, str.c_str());
            }
            if (materialData.name=="[弹]马格南") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 255, 0), 21, str.c_str());
            }
            if (materialData.name=="[弹]信号弹") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(0, 255, 0), 21, str.c_str());
            }
            if (materialData.name=="[镜]红点") {
               std::string str = materialData.name;
               imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="[镜]全息") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="[镜]3X") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="[镜]4X") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="[镜]6X") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="[镜]8X") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(70, 130, 180), 21, str.c_str());
            }
            if (materialData.name=="[投]手雷") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 127, 80), 21, str.c_str());
            }
            if (materialData.name=="[投]烟雾弹") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 127, 80), 21, str.c_str());
            }
            if (materialData.name=="[投]燃烧瓶") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 127, 80), 21, str.c_str());
            }
            if (materialData.name=="[狙配件]托腮板") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[狙配件]子弹袋") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[狙配件]子弹袋") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[狙配件]消焰器") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[狙配件]枪口补偿") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[狙配件]消音器") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[狙配件]快速扩容") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[狙配件]扩容") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[握]拇指握把") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[握]垂直握把") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[握]半截式握把") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[配件]枪口补偿") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[配件]战术枪托") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[配件]消焰器") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[配件]消音器") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[配件]快速扩容") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
            if (materialData.name=="[配件]扩容") {
               std::string str = materialData.name;
                imDrawList->AddTextX(ImVec2(materialData.screen.x+1 - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y+1), ImColor(0, 0, 0, 255), 21, str.c_str());
               imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(str.c_str(), 21) / 2, materialData.screen.y), ImColor(255, 255, 80), 21, str.c_str());
            }
                
            }
        }
        //物品贴图
        if (self.moduleControl->playerSwitch.WZStatus) {
        if (materialData.name=="[预警]小心手雷") {
                imDrawList->AddImage((__bridge ImTextureID) shouleiTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
            }
        if (materialData.name=="吉普") {
                imDrawList->AddImage((__bridge ImTextureID) JPTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
           }
        if (materialData.name=="蹦蹦") {
                imDrawList->AddImage((__bridge ImTextureID) BBTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
            }
        if (materialData.name=="轿车") {
            imDrawList->AddImage((__bridge ImTextureID) jcTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="摩托艇") {
            imDrawList->AddImage((__bridge ImTextureID) mttTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="摩托车") {
            imDrawList->AddImage((__bridge ImTextureID) mtTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="小绵羊") {
            imDrawList->AddImage((__bridge ImTextureID) myTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="CoupeRB") {
            imDrawList->AddImage((__bridge ImTextureID) R8Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="三轮摩托") {
            imDrawList->AddImage((__bridge ImTextureID) mt3Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        
        if (materialData.name=="M416") {
            imDrawList->AddImage((__bridge ImTextureID) m416Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="AKM") {
            imDrawList->AddImage((__bridge ImTextureID) akmTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="AUG") {
            imDrawList->AddImage((__bridge ImTextureID) augTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="Groza") {
            imDrawList->AddImage((__bridge ImTextureID) grozaTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="M16A4") {
            imDrawList->AddImage((__bridge ImTextureID) m16Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="M24") {
            imDrawList->AddImage((__bridge ImTextureID) m24Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="大菠萝") {
            imDrawList->AddImage((__bridge ImTextureID) m249Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="M762") {
            imDrawList->AddImage((__bridge ImTextureID) m762Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="MG3") {
            imDrawList->AddImage((__bridge ImTextureID) mg3Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="Mini14") {
            imDrawList->AddImage((__bridge ImTextureID) miniTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="Mk14") {
            imDrawList->AddImage((__bridge ImTextureID) mk14Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="Mk47") {
            imDrawList->AddImage((__bridge ImTextureID) mk47Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="SCAR-L") {
            imDrawList->AddImage((__bridge ImTextureID) scarTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="SLR") {
            imDrawList->AddImage((__bridge ImTextureID) slrTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="AWM") {
            imDrawList->AddImage((__bridge ImTextureID) awmTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="大盘鸡") {
            imDrawList->AddImage((__bridge ImTextureID) dp28Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="Kar98k") {
            imDrawList->AddImage((__bridge ImTextureID) k98Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="SKS") {
            imDrawList->AddImage((__bridge ImTextureID) sksTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="[盒子]") {
            imDrawList->AddImage((__bridge ImTextureID) hzTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="盒子") {
            imDrawList->AddImage((__bridge ImTextureID) ktTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+17 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+17 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        
        if (materialData.name=="饮料") {
            imDrawList->AddImage((__bridge ImTextureID) ylTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="止痛药") {
            imDrawList->AddImage((__bridge ImTextureID) ztyTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="急救包") {
            imDrawList->AddImage((__bridge ImTextureID) jjbTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="医疗箱") {
            imDrawList->AddImage((__bridge ImTextureID) ylxTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="肾上腺素") {
            imDrawList->AddImage((__bridge ImTextureID) zhenTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        
        if (materialData.name=="4X") {
            imDrawList->AddImage((__bridge ImTextureID) b4Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="3X") {
            imDrawList->AddImage((__bridge ImTextureID) b3Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="6X") {
            imDrawList->AddImage((__bridge ImTextureID) b6Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="8X") {
            imDrawList->AddImage((__bridge ImTextureID) b8Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="[空投]") {
            imDrawList->AddImage((__bridge ImTextureID) ktTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="空投") {
            imDrawList->AddImage((__bridge ImTextureID) ktTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="三级头") {
            imDrawList->AddImage((__bridge ImTextureID) t3Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="三级甲") {
            imDrawList->AddImage((__bridge ImTextureID) j3Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="三级包") {
            imDrawList->AddImage((__bridge ImTextureID) bb3Texture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="手雷") {
            imDrawList->AddImage((__bridge ImTextureID) tleiTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="烟雾弹") {
            imDrawList->AddImage((__bridge ImTextureID) tyanTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        if (materialData.name=="燃烧瓶") {
            imDrawList->AddImage((__bridge ImTextureID) thuoTexture, ImVec2(materialData.screen.x+165 - scWidth+1, materialData.screen.y+10 -  scHeight+1), ImVec2(materialData.screen.x+165 - scWidth+1 + scHeight-2 , materialData.screen.y+10 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        }
        //物品距离——贴图
        if (materialData.distance != -100) {
                 std::string str = std::to_string(materialData.distance) + "M";
                imDrawList->AddTextX(ImVec2(materialData.screen.x-14 - calcTextSize(std::to_string(materialData.distance).c_str(), 22) / 2, materialData.screen.y-4 ), ImColor(255, 255,0), 22, str.c_str());
            } else {
                 std::string str = materialData.name + ":";//盒子内物资
                imDrawList->AddRectFilled({materialData.screen.x - calcTextSize(materialData.name.c_str(), 22) / 2, materialData.screen.y }, {materialData.screen.x + calcTextSize(materialData.name.c_str(), 22) / 2, materialData.screen.y + 22}, ImColor(0, 0, 0, 80), 10.0f);
                imDrawList->AddTextX(ImVec2(materialData.screen.x - calcTextSize(materialData.name.c_str(), 22) / 2, materialData.screen.y + (22 / 2 - 22 / 2)), ImColor(255, 255, 255), 22, materialData.name.c_str());
            }
        }
    }
    if (self.moduleControl->mainSwitch.playerStatus) {
        //雷达UI
        if (self.moduleControl->playerSwitch.radarStatus) {
            //底色
            imDrawList->AddCircleFilled({self.moduleControl->playerSwitch.radarCoord.x, self.moduleControl->playerSwitch.radarCoord.y}, 225 * (self.moduleControl->playerSwitch.radarSize / 100), ImColor(0, 0, 0,30));
            //外形
            imDrawList->AddCircle({self.moduleControl->playerSwitch.radarCoord.x, self.moduleControl->playerSwitch.radarCoord.y}, 225 * (self.moduleControl->playerSwitch.radarSize / 100), ImColor(255, 0, 0), 0, 1.0f);
            //内圈
            imDrawList->AddCircle({self.moduleControl->playerSwitch.radarCoord.x, self.moduleControl->playerSwitch.radarCoord.y}, 110 * (self.moduleControl->playerSwitch.radarSize / 100), ImColor(0, 128, 128), 0, 1.0f);
            //内圈底色
            imDrawList->AddCircleFilled({self.moduleControl->playerSwitch.radarCoord.x, self.moduleControl->playerSwitch.radarCoord.y}, 110 * (self.moduleControl->playerSwitch.radarSize / 100), ImColor(0, 128,128,30));
            
            //T
            imDrawList->AddLine({(float) (self.moduleControl->playerSwitch.radarCoord.x - 225 * (self.moduleControl->playerSwitch.radarSize / 100)), self.moduleControl->playerSwitch.radarCoord.y}, {(float) (self.moduleControl->playerSwitch.radarCoord.x + 225 * (self.moduleControl->playerSwitch.radarSize / 100)), self.moduleControl->playerSwitch.radarCoord.y}, ImColor(0, 200, 0), 1.0f);
            imDrawList->AddLine({self.moduleControl->playerSwitch.radarCoord.x, self.moduleControl->playerSwitch.radarCoord.y}, {self.moduleControl->playerSwitch.radarCoord.x, (float) (self.moduleControl->playerSwitch.radarCoord.y + 225 * (self.moduleControl->playerSwitch.radarSize / 100))}, ImColor(0, 200, 0), 1.0f);
            // \/
            ImVec2 rotation = rotateCoord(130, ImVec2(0, 225 * (self.moduleControl->playerSwitch.radarSize / 100)));
            imDrawList->AddLine({self.moduleControl->playerSwitch.radarCoord.x, self.moduleControl->playerSwitch.radarCoord.y}, {self.moduleControl->playerSwitch.radarCoord.x + rotation.x, self.moduleControl->playerSwitch.radarCoord.y + rotation.y}, ImColor(200, 0, 0), 1.0f);
            //————
            rotation = rotateCoord(-130, ImVec2(0, 225 * (self.moduleControl->playerSwitch.radarSize / 100)));
            imDrawList->AddLine({self.moduleControl->playerSwitch.radarCoord.x, self.moduleControl->playerSwitch.radarCoord.y}, {self.moduleControl->playerSwitch.radarCoord.x + rotation.x, self.moduleControl->playerSwitch.radarCoord.y + rotation.y}, ImColor(200, 0, 0), 1.0f);
        }
        //清空人数
        int playerCount = 0, robotCount = 0;
        for (PlayerData playerData:playerDataList) {
            //人机数量和真人数量
            ImColor color, color150;
            if (!playerData.robot) {//真人
                if (playerData.visibility) {
                    color = ImColor(255, 0, 0);//可见
                } else {
                    color = ImColor(255, 255, 0);//不可见
                }
                playerCount += 1;
            } else {
                if (playerData.visibility) {
                    color = ImColor(0, 255, 0);//可见
                } else {
                    color = ImColor(255, 255, 255);//不可见
                }
                robotCount += 1;
            }
            //雷达UI
            if (self.moduleControl->playerSwitch.radarStatus) {//圆点
                imDrawList->AddCircleFilled({(float) (self.moduleControl->playerSwitch.radarCoord.x + playerData.radar.x * (self.moduleControl->playerSwitch.radarSize / 100)), (float) (self.moduleControl->playerSwitch.radarCoord.y + playerData.radar.y * (self.moduleControl->playerSwitch.radarSize / 100))}, 8, color);
                std::string str = std::to_string(playerData.distance) + "M";//距离
                imDrawList->AddTextX(ImVec2((float) (self.moduleControl->playerSwitch.radarCoord.x + playerData.radar.x * (self.moduleControl->playerSwitch.radarSize / 100) + 12), (float) (self.moduleControl->playerSwitch.radarCoord.y + playerData.radar.y * (self.moduleControl->playerSwitch.radarSize / 100) - 12)), color, 24, str.c_str());
            }
            //判断是否在屏幕内
            if (playerData.screen.x - hpWidth < screenSize.width && playerData.screen.x + hpWidth > 0 && playerData.screen.y > 0 && playerData.screen.y < screenSize.height) {
                if (self.moduleControl->playerSwitch.infoStatus) {
                    //底边边距
             //       int infoBottomMargin = playerData.distance / 7 + 5;
                    if (!playerData.robot) {
                    //血条
                    if (playerData.hp<=1) {
                    imDrawList->AddRectFilled({playerData.screen.x - hpWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x - hpWidth + (hpWidth * 2) , playerData.screen.y - playerData.size.y-10 }, ImColor(255, 165, 0));
                    } else {
                    imDrawList->AddRectFilled({playerData.screen.x - hpWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x - hpWidth + (hpWidth * 2) * playerData.hp / 100, playerData.screen.y - playerData.size.y-10 }, ImColor(255, 0, 0));
                    }
                    //血条边框
                    imDrawList->AddRect({playerData.screen.x+40 - xtWidth, playerData.screen.y - playerData.size.y-10 - hpHeight}, {playerData.screen.x+40 + xtWidth, playerData.screen.y - playerData.size.y-10 }, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    imDrawList->AddRect({playerData.screen.x+20 - xtWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x+20 + xtWidth, playerData.screen.y - playerData.size.y-10 }, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    imDrawList->AddRect({playerData.screen.x - xtWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x + xtWidth, playerData.screen.y - playerData.size.y-10}, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    imDrawList->AddRect({playerData.screen.x-20 - xtWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x-20 + xtWidth, playerData.screen.y - playerData.size.y-10 }, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    imDrawList->AddRect({playerData.screen.x-40 - xtWidth, playerData.screen.y - playerData.size.y-10 - hpHeight}, {playerData.screen.x-40 + xtWidth, playerData.screen.y - playerData.size.y-10 }, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    //名字,对编
                    std::string str = std::to_string(playerData.team) + ":" + playerData.name;
                    imDrawList->AddTextX(ImVec2(playerData.screen.x+24- calcTextSize(std::string(playerData.name).c_str(), 19) / 2 - hpWidth + hpHeight + 4, playerData.screen.y - playerData.size.y-22  - hpHeight / 2 - 12), ImColor(0, 0, 0, 255), 19, str.c_str());
                    imDrawList->AddTextX(ImVec2(playerData.screen.x+23- calcTextSize(std::string(playerData.name).c_str(), 19) / 2 - hpWidth + hpHeight + 4, playerData.screen.y - playerData.size.y-23  - hpHeight / 2 - 12), ImColor(255, 255, 0), 19, str.c_str());
                    //距离
                    str = std::to_string(playerData.distance) + "M";
                    imDrawList->AddTextX(ImVec2(playerData.bonesData.rknee.x-22 - calcTextSize(std::to_string(playerData.distance).c_str(), 20) / 6, playerData.bonesData.rknee.y+21 - hpHeight ), ImColor(0, 0, 0, 255), 23, str.c_str());
                    imDrawList->AddTextX(ImVec2(playerData.bonesData.rknee.x-23 - calcTextSize(std::to_string(playerData.distance).c_str(), 20) / 6, playerData.bonesData.rknee.y+20 - hpHeight ), ImColor(255, 255, 0), 23, str.c_str());
                } else {
                    if (playerData.hp<=1) {
                    imDrawList->AddRectFilled({playerData.screen.x - hpWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x - hpWidth + (hpWidth * 2) , playerData.screen.y - playerData.size.y-10 }, ImColor(255, 165, 0));
                    } else {
                    imDrawList->AddRectFilled({playerData.screen.x - hpWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x - hpWidth + (hpWidth * 2) * playerData.hp / 100, playerData.screen.y - playerData.size.y-10 }, ImColor(255, 255, 255));
                    }
                    //血条边框
                    imDrawList->AddRect({playerData.screen.x+40 - xtWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x+40 + xtWidth, playerData.screen.y - playerData.size.y-10 }, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    imDrawList->AddRect({playerData.screen.x+20 - xtWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x+20 + xtWidth, playerData.screen.y - playerData.size.y-10 }, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    imDrawList->AddRect({playerData.screen.x - xtWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x + xtWidth, playerData.screen.y - playerData.size.y-10 }, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    imDrawList->AddRect({playerData.screen.x-20 - xtWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x-20 + xtWidth, playerData.screen.y - playerData.size.y-10 }, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    imDrawList->AddRect({playerData.screen.x-40 - xtWidth, playerData.screen.y - playerData.size.y-10  - hpHeight}, {playerData.screen.x-40 + xtWidth, playerData.screen.y - playerData.size.y-10 }, ImColor(0, 0, 0, 255),0.0f, 0, 2.0f);
                    
                    
                    //名字,对编
                    std::string str = std::to_string(playerData.team) + ":" + playerData.name;
                    imDrawList->AddTextX(ImVec2(playerData.screen.x+24- calcTextSize(std::string(playerData.name).c_str(), 19) / 2 - hpWidth + hpHeight + 4, playerData.screen.y - playerData.size.y-22  - hpHeight / 2 - 12), ImColor(0, 0, 0, 255), 19, str.c_str());
                    imDrawList->AddTextX(ImVec2(playerData.screen.x+23- calcTextSize(std::string(playerData.name).c_str(), 19) / 2 - hpWidth + hpHeight + 4, playerData.screen.y - playerData.size.y-23  - hpHeight / 2 - 12), ImColor(255, 255, 255), 19, str.c_str());
                    //距离
                    str = std::to_string(playerData.distance) + "M";
                    imDrawList->AddTextX(ImVec2(playerData.bonesData.rknee.x-22 - calcTextSize(std::to_string(playerData.distance).c_str(), 20) / 6, playerData.bonesData.rknee.y+21  - hpHeight ), ImColor(0, 0, 0, 255), 23, str.c_str());
                    imDrawList->AddTextX(ImVec2(playerData.bonesData.rknee.x-23 - calcTextSize(std::to_string(playerData.distance).c_str(), 20) / 6, playerData.bonesData.rknee.y+20  - hpHeight ), ImColor(255, 255, 255), 23, str.c_str());
            }
                   //手持武器文字
           if (self.moduleControl->playerSwitch.SCWZStatus) {
                    imDrawList->AddTextX(ImVec2(playerData.screen.x+4 - calcTextSize(playerData.weaponName.c_str(), 20) / 2, playerData.screen.y - playerData.size.y-19  - hpHeight- 32), ImColor(0, 0, 0, 255), 20, playerData.weaponName.c_str());
                    imDrawList->AddTextX(ImVec2(playerData.screen.x+3 - calcTextSize(playerData.weaponName.c_str(), 20) / 2, playerData.screen.y - playerData.size.y-20  - hpHeight- 32), ImColor(255, 255, 255), 20, playerData.weaponName.c_str());
                    
                    imDrawList->AddTextX(ImVec2(playerData.screen.x+4 - calcTextSize(playerData.statusName.c_str(), 20) / 2, playerData.screen.y - playerData.size.y-39  - hpHeight- 32), ImColor(0, 0, 0, 255), 20, playerData.statusName.c_str());
                    imDrawList->AddTextX(ImVec2(playerData.screen.x+3 - calcTextSize(playerData.statusName.c_str(), 20) / 2, playerData.screen.y - playerData.size.y-40  - hpHeight- 32), ImColor(0, 191, 255), 20, playerData.statusName.c_str());
                   
              
           }
                    //手持武器贴图
            if (self.moduleControl->playerSwitch.SCStatus) {
                if (playerData.weaponName=="拳头") {
                   imDrawList->AddImage((__bridge ImTextureID) quanTexture, ImVec2(playerData.screen.x+200 - qtWidth+1, playerData.screen.y-30 - playerData.size.y -5 - qtHeight+1), ImVec2(playerData.screen.x+200 - qtWidth+1 + qtHeight-2 , playerData.screen.y-30 - playerData.size.y -5 - qtHeight + qtHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                   } 
                if (playerData.weaponName=="[机枪]大盘鸡") {
                   imDrawList->AddImage((__bridge ImTextureID) DP28Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[机枪]大菠萝") {
                   imDrawList->AddImage((__bridge ImTextureID) M249Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[机枪]MG3") {
                   imDrawList->AddImage((__bridge ImTextureID) MG3Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[霰弹枪]S686") {
                   imDrawList->AddImage((__bridge ImTextureID) S686Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[霰弹枪]DBS") {
                   imDrawList->AddImage((__bridge ImTextureID) DBSTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[霰弹枪]S12K") {
                   imDrawList->AddImage((__bridge ImTextureID) S12KTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                     }
                if (playerData.weaponName=="[冲锋枪]Bison") {
                   imDrawList->AddImage((__bridge ImTextureID) YNTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[步枪]QBZ") {
                   imDrawList->AddImage((__bridge ImTextureID) QBZTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[步枪]M416") {
                   imDrawList->AddImage((__bridge ImTextureID) M416Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]QBU") {
                   imDrawList->AddImage((__bridge ImTextureID) QBUTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]SLR") {
                   imDrawList->AddImage((__bridge ImTextureID) SLRTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]SKS") {
                   imDrawList->AddImage((__bridge ImTextureID) SKSTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]Mini14") {
                   imDrawList->AddImage((__bridge ImTextureID) MINITexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]M24") {
                   imDrawList->AddImage((__bridge ImTextureID) M24Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]Kar98k") {
                   imDrawList->AddImage((__bridge ImTextureID) K98Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]AWM") {
                   imDrawList->AddImage((__bridge ImTextureID) AWMTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]Mk14") {
                   imDrawList->AddImage((__bridge ImTextureID) MK14Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]莫辛纳甘") {
                   imDrawList->AddImage((__bridge ImTextureID) MOTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[狙击枪]VSS") {
                   imDrawList->AddImage((__bridge ImTextureID) VSSTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                
                if (playerData.weaponName=="[步枪]M762") {
                   imDrawList->AddImage((__bridge ImTextureID) M762Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[步枪]SCAR-L") {
                   imDrawList->AddImage((__bridge ImTextureID) SCARTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[步枪]M16A4") {
                   imDrawList->AddImage((__bridge ImTextureID) M16Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[步枪]Mk47") {
                   imDrawList->AddImage((__bridge ImTextureID) MK47Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[步枪]Groza") {
                   imDrawList->AddImage((__bridge ImTextureID) GrozaTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[步枪]AUG") {
                   imDrawList->AddImage((__bridge ImTextureID) AUGTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[步枪]AKM") {
                   imDrawList->AddImage((__bridge ImTextureID) AkmTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                
                if (playerData.weaponName=="[投掷物]手雷") {
                   imDrawList->AddImage((__bridge ImTextureID) leiTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[投掷物]烟雾弹") {
                   imDrawList->AddImage((__bridge ImTextureID) yanTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[投掷物]燃烧瓶") {
                   imDrawList->AddImage((__bridge ImTextureID) huoTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                
                if (playerData.weaponName=="[近战]平底锅") {
                   imDrawList->AddImage((__bridge ImTextureID) GUOTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                
                if (playerData.weaponName=="[近战]镰刀") {
                   imDrawList->AddImage((__bridge ImTextureID) LIANTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                
                if (playerData.weaponName=="[近战]大砍刀") {
                   imDrawList->AddImage((__bridge ImTextureID) DAOTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[近战]撬棍") {
                   imDrawList->AddImage((__bridge ImTextureID) GUNTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[冲锋枪]MP5K") {
                   imDrawList->AddImage((__bridge ImTextureID) MP5KTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[冲锋枪]TommyGun") {
                   imDrawList->AddImage((__bridge ImTextureID) TANGTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[冲锋枪]UMP9") {
                   imDrawList->AddImage((__bridge ImTextureID) UMP9Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                
                if (playerData.weaponName=="[冲锋枪]Uzi") {
                   imDrawList->AddImage((__bridge ImTextureID) UZITexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[冲锋枪]Vector") {
                   imDrawList->AddImage((__bridge ImTextureID) VKTTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                
                if (playerData.weaponName=="[手枪]P92") {
                   imDrawList->AddImage((__bridge ImTextureID) P92Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[手枪]P1911") {
                   imDrawList->AddImage((__bridge ImTextureID) P1911Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[手枪]R1895") {
                   imDrawList->AddImage((__bridge ImTextureID) R1895Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[手枪]P18C") {
                   imDrawList->AddImage((__bridge ImTextureID) P18CTexture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                if (playerData.weaponName=="[手枪]R45") {
                   imDrawList->AddImage((__bridge ImTextureID) R45Texture, ImVec2(playerData.screen.x+160 - scWidth+1, playerData.screen.y+2 - playerData.size.y -5 - scHeight+1), ImVec2(playerData.screen.x+160 - scWidth+1 + scHeight-2 , playerData.screen.y+2 - playerData.size.y -5 - scHeight + scHeight-1), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
                }
                
                }
              
                }
                
                //绘制射线
                if (self.moduleControl->playerSwitch.lineStatus) {
                    if (playerData.hp<=1){
                    imDrawList->AddLine(ImVec2(screenSize.width / 2, 120), ImVec2(playerData.screen.x, playerData.screen.y - playerData.size.y-90), ImColor(255,165,0), 2.0f);
                }else{
                    imDrawList->AddLine(ImVec2(screenSize.width / 2, 120), ImVec2(playerData.screen.x, playerData.screen.y - playerData.size.y-90), color, 2.0f);
                }
                }
                //绘制方框
                if (self.moduleControl->playerSwitch.boxStatus) {
                    if (playerData.hp<=1){
                    imDrawList->AddRect({playerData.screen.x - playerData.size.x, playerData.screen.y - playerData.size.y}, {playerData.screen.x + playerData.size.x, playerData.screen.y + playerData.size.y}, ImColor(255,165,0), 10.0f, 0, 2.0f);
                }else{
                    imDrawList->AddRect({playerData.screen.x - playerData.size.x, playerData.screen.y - playerData.size.y}, {playerData.screen.x + playerData.size.x, playerData.screen.y + playerData.size.y}, color, 10.0f, 0, 2.0f);
                }
                }
                //绘制骨骼
                if (self.moduleControl->playerSwitch.boneStatus) {
                    imDrawList->AddLine({playerData.bonesData.head.x, playerData.bonesData.head.y}, {playerData.bonesData.pit.x, playerData.bonesData.pit.y}, color, 2.0f);
                    imDrawList->AddLine({playerData.bonesData.pit.x, playerData.bonesData.pit.y}, {playerData.bonesData.pelvis.x, playerData.bonesData.pelvis.y}, color, 2.0f);
                    
                    imDrawList->AddLine({playerData.bonesData.pit.x, playerData.bonesData.pit.y}, {playerData.bonesData.lcollar.x, playerData.bonesData.lcollar.y}, color, 2.0f);
                    imDrawList->AddLine({playerData.bonesData.lcollar.x, playerData.bonesData.lcollar.y}, {playerData.bonesData.lelbow.x, playerData.bonesData.lelbow.y}, color,2.0f);
                    imDrawList->AddLine({playerData.bonesData.lelbow.x, playerData.bonesData.lelbow.y}, {playerData.bonesData.lwrist.x, playerData.bonesData.lwrist.y}, color, 2.0f);
                    
                    imDrawList->AddLine({playerData.bonesData.pit.x, playerData.bonesData.pit.y}, {playerData.bonesData.rcollar.x, playerData.bonesData.rcollar.y}, color, 2.0f);
                    imDrawList->AddLine({playerData.bonesData.rcollar.x, playerData.bonesData.rcollar.y}, {playerData.bonesData.relbow.x, playerData.bonesData.relbow.y}, color, 2.0f);
                    imDrawList->AddLine({playerData.bonesData.relbow.x, playerData.bonesData.relbow.y}, {playerData.bonesData.rwrist.x, playerData.bonesData.rwrist.y}, color,2.0f);
                    
                    imDrawList->AddLine({playerData.bonesData.pelvis.x, playerData.bonesData.pelvis.y}, {playerData.bonesData.lthigh.x, playerData.bonesData.lthigh.y}, color,2.0f);
                    imDrawList->AddLine({playerData.bonesData.lthigh.x, playerData.bonesData.lthigh.y}, {playerData.bonesData.lknee.x, playerData.bonesData.lknee.y}, color, 2.0f);
                    imDrawList->AddLine({playerData.bonesData.lknee.x, playerData.bonesData.lknee.y}, {playerData.bonesData.lankle.x, playerData.bonesData.lankle.y}, color, 2.0f);
                    
                    imDrawList->AddLine({playerData.bonesData.pelvis.x, playerData.bonesData.pelvis.y}, {playerData.bonesData.rthigh.x, playerData.bonesData.rthigh.y}, color, 2.0f);
                    imDrawList->AddLine({playerData.bonesData.rthigh.x, playerData.bonesData.rthigh.y}, {playerData.bonesData.rknee.x, playerData.bonesData.rknee.y}, color, 2.0f);
                    imDrawList->AddLine({playerData.bonesData.rknee.x, playerData.bonesData.rknee.y}, {playerData.bonesData.rankle.x, playerData.bonesData.rankle.y}, color, 2.0f);
                }
                } else if (self.moduleControl->playerSwitch.backStatus) {//背敌预警
                ImVec2 backAngle = rotateCoord(playerData.angle,ImVec2(320, 0));
                
                ImVec2 backAngle1 = rotateCoord(playerData.angle, ImVec2(325, 0));
                
                ImVec2 triangle1;
                triangle1 = rotateCoord(playerData.angle - 90, ImVec2(30, 0));
                triangle1.x += screenSize.width / 2 + backAngle.x;
                triangle1.y += screenSize.height / 2 + backAngle.y;

                ImVec2 triangle;
                triangle = rotateCoord(playerData.angle, ImVec2(40, 0));
                triangle.x += screenSize.width / 2 + backAngle.x;
                triangle.y += screenSize.height / 2 + backAngle.y;

                ImVec2 triangle2;
                triangle2 = rotateCoord(playerData.angle + 90, ImVec2(30, 0));
                triangle2.x += screenSize.width / 2 + backAngle.x;
                triangle2.y += screenSize.height / 2 + backAngle.y;
                    
                if(playerData.hp<=1){
                imDrawList->AddTriangleFilled(triangle1, triangle, triangle2, ImColor(255,165,0));//三角形
                imDrawList->AddTriangle(triangle1, triangle, triangle2, ImColor(0, 0, 0, 255),2);
                }else{
                imDrawList->AddTriangleFilled(triangle1, triangle, triangle2, color);//三角形
                imDrawList->AddTriangle(triangle1, triangle, triangle2, ImColor(0, 0, 0, 255),2);
                }
                std::string str = std::to_string(playerData.distance);
                if (!playerData.robot) {//真人
                    if (color == ImColor(255, 255, 0)) {
                        imDrawList->AddTextX(ImVec2(screenSize.width / 2+1.5 + backAngle1.x - calcTextSize(str.c_str(), 40) / 2, screenSize.height / 2 + backAngle.y - 14.5), ImColor(0, 0, 0, 255), 30, str.c_str());
                        imDrawList->AddTextX(ImVec2(screenSize.width / 2 + backAngle1.x - calcTextSize(str.c_str(), 40) / 2, screenSize.height / 2 + backAngle.y - 16), ImColor(255, 0, 0), 30, str.c_str());
                    } else {
                        imDrawList->AddTextX(ImVec2(screenSize.width / 2+1.5 + backAngle1.x - calcTextSize(str.c_str(), 40) / 2, screenSize.height / 2 + backAngle.y - 14.5), ImColor(0, 0, 0, 255), 30, str.c_str());
                        imDrawList->AddTextX(ImVec2(screenSize.width / 2 + backAngle1.x - calcTextSize(str.c_str(), 40) / 2, screenSize.height / 2 + backAngle.y - 16), ImColor(255, 255, 0), 30, str.c_str());
                    
                    }
                } else {
                    if (color == ImColor(0, 255, 0)) {
                        imDrawList->AddTextX(ImVec2(screenSize.width / 2+1.5 + backAngle.x - calcTextSize(str.c_str(), 40) / 2, screenSize.height / 2 + backAngle.y - 14.5), ImColor(0, 0, 0, 255), 36, str.c_str());
                        imDrawList->AddTextX(ImVec2(screenSize.width / 2 + backAngle.x - calcTextSize(str.c_str(), 40) / 2, screenSize.height / 2 + backAngle.y - 16), ImColor(255, 255, 255), 36, str.c_str());
                    } else {
                        imDrawList->AddTextX(ImVec2(screenSize.width / 2+1.5 + backAngle.x - calcTextSize(str.c_str(), 40) / 2, screenSize.height / 2 + backAngle.y - 14.5), ImColor(0, 0, 0, 255), 36, str.c_str());
                        imDrawList->AddTextX(ImVec2(screenSize.width / 2 + backAngle.x - calcTextSize(str.c_str(), 40) / 2, screenSize.height / 2 + backAngle.y - 16), ImColor(0, 255, 0), 36, str.c_str());
                    }
                }
            }
        }
        //绘制人数
        imDrawList->AddImage((__bridge ImTextureID) count4Texture, ImVec2(screenSize.width / 2-95 - count4Texture.width / 2, 115), ImVec2(screenSize.width / 2-95 + count4Texture.width / 2, 115 + count4Texture.height), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        imDrawList->AddImage((__bridge ImTextureID) count5Texture, ImVec2(screenSize.width / 2+95 - count5Texture.width / 2, 115), ImVec2(screenSize.width / 2+95 + count5Texture.width / 2, 115 + count5Texture.height), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        /*
        imDrawList->AddImage((__bridge ImTextureID) count4Texture, ImVec2(screenSize.width / 2 - count4Texture.width / 2, 60), ImVec2(screenSize.width / 2 + count4Texture.width / 2, 60 + count4Texture.height), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        */
        if (playerCount == 0 && robotCount == 0) {//安全贴图
            imDrawList->AddImage((__bridge ImTextureID) count1Texture, ImVec2(screenSize.width / 2 - count1Texture.width / 2, 114), ImVec2(screenSize.width / 2 + count1Texture.width / 2, 114 + count1Texture.height), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
        } else {
            if(robotCount == 0){//人机黄色警告
                imDrawList->AddTextX(ImVec2(screenSize.width / 2 + 36.5, 101.5 + countTexture.height / 2 - 20), ImColor(0, 0, 0, 255),45, std::to_string(robotCount).c_str());
                imDrawList->AddTextX(ImVec2(screenSize.width / 2 + 35, 100 + countTexture.height / 2 - 20), ImColor(0, 255, 0), 45, std::to_string(robotCount).c_str());
            }else{
                imDrawList->AddTextX(ImVec2(screenSize.width / 2 + 36.5, 101.5 + countTexture.height / 2 - 20), ImColor(0, 0, 0, 255),45, std::to_string(robotCount).c_str());
                imDrawList->AddTextX(ImVec2(screenSize.width / 2 + 35, 100 + countTexture.height / 2 - 20), ImColor(255, 255, 0), 45, std::to_string(robotCount).c_str());
                imDrawList->AddImage((__bridge ImTextureID) count3Texture, ImVec2(screenSize.width / 2 - count3Texture.width / 2, 114), ImVec2(screenSize.width / 2 + count3Texture.width / 2, 114 + count3Texture.height), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
            }
            if(playerCount == 0){//真人红色警告
                imDrawList->AddTextX(ImVec2(screenSize.width / 2 - calcTextSize(std::to_string(playerCount).c_str(), 40) - 33.5, 101.5 + countTexture.height / 2 - 20), ImColor(0, 0, 0, 255), 45, std::to_string(playerCount).c_str());
                imDrawList->AddTextX(ImVec2(screenSize.width / 2 - calcTextSize(std::to_string(playerCount).c_str(), 40) - 35, 100 + countTexture.height / 2 - 20), ImColor(0, 255, 0), 45, std::to_string(playerCount).c_str());
            }else{
                imDrawList->AddTextX(ImVec2(screenSize.width / 2 - calcTextSize(std::to_string(playerCount).c_str(), 40) - 33.5, 101.5 + countTexture.height / 2 - 20), ImColor(0, 0, 0, 255), 45, std::to_string(playerCount).c_str());
                imDrawList->AddTextX(ImVec2(screenSize.width / 2 - calcTextSize(std::to_string(playerCount).c_str(), 40) - 35, 100 + countTexture.height / 2 - 20), ImColor(255, 0, 0), 45, std::to_string(playerCount).c_str());
                imDrawList->AddImage((__bridge ImTextureID) count2Texture, ImVec2(screenSize.width / 2 - count2Texture.width / 2, 114), ImVec2(screenSize.width / 2 + count2Texture.width / 2, 114 + count2Texture.height), ImVec2(0.0f, 0.0f), ImVec2(1.0f, 1.0f));
            }
        }
   }
        if (self.moduleControl->mainSwitch.aimbotStatus) {
        if (self.moduleControl->aimbotController.showAimbotRadius) {
            //自瞄圆圈
            imDrawList->AddCircle(ImVec2(screenSize.width / 2, screenSize.height / 2), self.moduleControl->aimbotController.aimbotRadius, ImColor(0, 255, 255), 0, 1.0f);
        }
    }
             
             
    
         ImGui::End();
}

-(void)initImageTexture: (id<MTLDevice>)device {
    NSData *countData = [[NSData alloc] initWithBase64EncodedString:countDataBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    countTexture = [self loadImageTexture : device : (void*)[countData bytes] : [countData length]];
    
    NSData *countData1 = [[NSData alloc] initWithBase64EncodedString:countData1Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    count1Texture = [self loadImageTexture : device : (void*)[countData1 bytes] : [countData1 length]];
    
    NSData *countData2 = [[NSData alloc] initWithBase64EncodedString:countData2Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    count2Texture = [self loadImageTexture : device : (void*)[countData2 bytes] : [countData2 length]];
    
    NSData *countData3 = [[NSData alloc] initWithBase64EncodedString:countData3Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    count3Texture = [self loadImageTexture : device : (void*)[countData3 bytes] : [countData3 length]];
    
    NSData *countData4 = [[NSData alloc] initWithBase64EncodedString:countData4Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    count4Texture = [self loadImageTexture : device : (void*)[countData4 bytes] : [countData4 length]];
    
    NSData *countData5 = [[NSData alloc] initWithBase64EncodedString:countData5Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    count5Texture = [self loadImageTexture : device : (void*)[countData5 bytes] : [countData5 length]];
    
    NSData *quan = [[NSData alloc] initWithBase64EncodedString:quanBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    quanTexture = [self loadImageTexture : device : (void*)[quan bytes] : [quan length]];
    
    NSData *shoulei = [[NSData alloc] initWithBase64EncodedString:shouleiBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    shouleiTexture = [self loadImageTexture : device : (void*)[shoulei bytes] : [shoulei length]];
    
    NSData *playerData = [[NSData alloc] initWithBase64EncodedString:playerDataBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    playerTexture = [self loadImageTexture : device : (void*)[playerData bytes] : [playerData length]];
    
    NSData *robotData = [[NSData alloc] initWithBase64EncodedString:robotDataBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    robotTexture = [self loadImageTexture : device : (void*)[robotData bytes] : [robotData length]];
    //手持武器
    NSData *M416 = [[NSData alloc] initWithBase64EncodedString:M416Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    M416Texture = [self loadImageTexture : device : (void*)[M416 bytes] : [M416 length]];
    
    NSData *M16 = [[NSData alloc] initWithBase64EncodedString:M16Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    M16Texture = [self loadImageTexture : device : (void*)[M16 bytes] : [M16 length]];

    NSData *Groza = [[NSData alloc] initWithBase64EncodedString:GrozaBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    GrozaTexture = [self loadImageTexture : device : (void*)[Groza bytes] : [Groza length]];

    NSData *Akm = [[NSData alloc] initWithBase64EncodedString:AkmBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    AkmTexture = [self loadImageTexture : device : (void*)[Akm bytes] : [Akm length]];

    NSData *SCAR = [[NSData alloc] initWithBase64EncodedString:SCARBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    SCARTexture = [self loadImageTexture : device : (void*)[SCAR bytes] : [SCAR length]];

    NSData *MK47 = [[NSData alloc] initWithBase64EncodedString:MK47Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    MK47Texture = [self loadImageTexture : device : (void*)[MK47 bytes] : [MK47 length]];

    NSData *AUG = [[NSData alloc] initWithBase64EncodedString:AUGBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    AUGTexture = [self loadImageTexture : device : (void*)[AUG bytes] : [AUG length]];

    NSData *M762 = [[NSData alloc] initWithBase64EncodedString:M762Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    M762Texture = [self loadImageTexture : device : (void*)[M762 bytes] : [M762 length]];
    
    NSData *QBZ = [[NSData alloc] initWithBase64EncodedString:QBZBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    QBZTexture = [self loadImageTexture : device : (void*)[QBZ bytes] : [QBZ length]];
    
    NSData *lei = [[NSData alloc] initWithBase64EncodedString:leiBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    leiTexture = [self loadImageTexture : device : (void*)[lei bytes] : [lei length]];
  
    NSData *huo = [[NSData alloc] initWithBase64EncodedString:huoBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    huoTexture = [self loadImageTexture : device : (void*)[huo bytes] : [huo length]];

    NSData *yan = [[NSData alloc] initWithBase64EncodedString:yanBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    yanTexture = [self loadImageTexture : device : (void*)[yan bytes] : [yan length]];

    NSData *shan = [[NSData alloc] initWithBase64EncodedString:shanBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    shanTexture = [self loadImageTexture : device : (void*)[shan bytes] : [shan length]];

    NSData *R1895 = [[NSData alloc] initWithBase64EncodedString:R1895Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    R1895Texture = [self loadImageTexture : device : (void*)[R1895 bytes] : [R1895 length]];

    NSData *P92 = [[NSData alloc] initWithBase64EncodedString:P92Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    P92Texture = [self loadImageTexture : device : (void*)[P92 bytes] : [P92 length]];

    NSData *P1911 = [[NSData alloc] initWithBase64EncodedString:P1911Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    P1911Texture = [self loadImageTexture : device : (void*)[P1911 bytes] : [P1911 length]];

    NSData *P18C = [[NSData alloc] initWithBase64EncodedString:P18CBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    P18CTexture = [self loadImageTexture : device : (void*)[P18C bytes] : [P18C length]];

    NSData *R45 = [[NSData alloc] initWithBase64EncodedString:R45Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    R45Texture = [self loadImageTexture : device : (void*)[R45 bytes] : [R45 length]];
 
    NSData *SKS = [[NSData alloc] initWithBase64EncodedString:SKSBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    SKSTexture = [self loadImageTexture : device : (void*)[SKS bytes] : [SKS length]];

    NSData *MINI = [[NSData alloc] initWithBase64EncodedString:MINIBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    MINITexture = [self loadImageTexture : device : (void*)[MINI bytes] : [MINI length]];

    NSData *MK14 = [[NSData alloc] initWithBase64EncodedString:MK14Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    MK14Texture = [self loadImageTexture : device : (void*)[MK14 bytes] : [MK14 length]];

    NSData *VSS = [[NSData alloc] initWithBase64EncodedString:VSSBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    VSSTexture = [self loadImageTexture : device : (void*)[VSS bytes] : [VSS length]];

    NSData *QBU = [[NSData alloc] initWithBase64EncodedString:QBUBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    QBUTexture = [self loadImageTexture : device : (void*)[QBU bytes] : [QBU length]];

    NSData *SLR = [[NSData alloc] initWithBase64EncodedString:SLRBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    SLRTexture = [self loadImageTexture : device : (void*)[SLR bytes] : [SLR length]];

    NSData *AWM = [[NSData alloc] initWithBase64EncodedString:AWMBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    AWMTexture = [self loadImageTexture : device : (void*)[AWM bytes] : [AWM length]];

    NSData *K98 = [[NSData alloc] initWithBase64EncodedString:K98Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    K98Texture = [self loadImageTexture : device : (void*)[K98 bytes] : [K98 length]];

    NSData *MO = [[NSData alloc] initWithBase64EncodedString:MOBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    MOTexture = [self loadImageTexture : device : (void*)[MO bytes] : [MO length]];

    NSData *LIAN = [[NSData alloc] initWithBase64EncodedString:LIANBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    LIANTexture = [self loadImageTexture : device : (void*)[LIAN bytes] : [LIAN length]];

    NSData *GUN = [[NSData alloc] initWithBase64EncodedString:GUNBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    GUNTexture = [self loadImageTexture : device : (void*)[GUN bytes] : [GUN length]];
 
    NSData *DAO = [[NSData alloc] initWithBase64EncodedString:DAOBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    DAOTexture = [self loadImageTexture : device : (void*)[DAO bytes] : [DAO length]];

    NSData *GUO = [[NSData alloc] initWithBase64EncodedString:GUOBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    GUOTexture = [self loadImageTexture : device : (void*)[GUO bytes] : [GUO length]];

    NSData *UZI = [[NSData alloc] initWithBase64EncodedString:UZIBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UZITexture = [self loadImageTexture : device : (void*)[UZI bytes] : [UZI length]];

    NSData *TANG = [[NSData alloc] initWithBase64EncodedString:TANGBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    TANGTexture = [self loadImageTexture : device : (void*)[TANG bytes] : [TANG length]];

    NSData *VKT = [[NSData alloc] initWithBase64EncodedString:VKTBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    VKTTexture = [self loadImageTexture : device : (void*)[VKT bytes] : [VKT length]];

    NSData *MP5K = [[NSData alloc] initWithBase64EncodedString:MP5KBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    MP5KTexture = [self loadImageTexture : device : (void*)[MP5K bytes] : [MP5K length]];

    NSData *UMP9 = [[NSData alloc] initWithBase64EncodedString:UMP9Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UMP9Texture = [self loadImageTexture : device : (void*)[UMP9 bytes] : [UMP9 length]];

    NSData *YN = [[NSData alloc] initWithBase64EncodedString:YNBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    YNTexture = [self loadImageTexture : device : (void*)[YN bytes] : [YN length]];
    
    NSData *M24 = [[NSData alloc] initWithBase64EncodedString:M24Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    M24Texture = [self loadImageTexture : device : (void*)[M24 bytes] : [M24 length]];

    NSData *DP28 = [[NSData alloc] initWithBase64EncodedString:DP28Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    DP28Texture = [self loadImageTexture : device : (void*)[DP28 bytes] : [DP28 length]];

    NSData *MG3 = [[NSData alloc] initWithBase64EncodedString:MG3Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    MG3Texture = [self loadImageTexture : device : (void*)[MG3 bytes] : [MG3 length]];

    NSData *M249 = [[NSData alloc] initWithBase64EncodedString:M249Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    M249Texture = [self loadImageTexture : device : (void*)[M249 bytes] : [M249 length]];

    NSData *DBS = [[NSData alloc] initWithBase64EncodedString:DBSBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    DBSTexture = [self loadImageTexture : device : (void*)[DBS bytes] : [DBS length]];

    NSData *S686 = [[NSData alloc] initWithBase64EncodedString:S686Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    S686Texture = [self loadImageTexture : device : (void*)[S686 bytes] : [S686 length]];

    NSData *S12K = [[NSData alloc] initWithBase64EncodedString:S12KBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    S12KTexture = [self loadImageTexture : device : (void*)[S12K bytes] : [S12K length]];

    //载具
    NSData *JP = [[NSData alloc] initWithBase64EncodedString:JPBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    JPTexture = [self loadImageTexture : device : (void*)[JP bytes] : [JP length]];

    NSData *BB = [[NSData alloc] initWithBase64EncodedString:BBBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    BBTexture = [self loadImageTexture : device : (void*)[BB bytes] : [BB length]];

    NSData *jc = [[NSData alloc] initWithBase64EncodedString:jcBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    jcTexture = [self loadImageTexture : device : (void*)[jc bytes] : [jc length]];
    
    NSData *mtt = [[NSData alloc] initWithBase64EncodedString:mttBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    mttTexture = [self loadImageTexture : device : (void*)[mtt bytes] : [mtt length]];
    
    NSData *mt = [[NSData alloc] initWithBase64EncodedString:mtBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    mtTexture = [self loadImageTexture : device : (void*)[mt bytes] : [mt length]];
    
    NSData *my = [[NSData alloc] initWithBase64EncodedString:myBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    myTexture = [self loadImageTexture : device : (void*)[my bytes] : [my length]];
    
    NSData *R8 = [[NSData alloc] initWithBase64EncodedString:R8Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    R8Texture = [self loadImageTexture : device : (void*)[R8 bytes] : [R8 length]];
    
    NSData *mt3 = [[NSData alloc] initWithBase64EncodedString:mt3Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    mt3Texture = [self loadImageTexture : device : (void*)[mt3 bytes] : [mt3 length]];
    
    NSData *m416 = [[NSData alloc] initWithBase64EncodedString:m416Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    m416Texture = [self loadImageTexture : device : (void*)[m416 bytes] : [m416 length]];

    NSData *akm = [[NSData alloc] initWithBase64EncodedString:akmBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    akmTexture = [self loadImageTexture : device : (void*)[akm bytes] : [akm length]];
    
    NSData *aug = [[NSData alloc] initWithBase64EncodedString:augBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    augTexture = [self loadImageTexture : device : (void*)[aug bytes] : [aug length]];
    
    NSData *groza = [[NSData alloc] initWithBase64EncodedString:grozaBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    grozaTexture = [self loadImageTexture : device : (void*)[groza bytes] : [groza length]];
    
    NSData *m16 = [[NSData alloc] initWithBase64EncodedString:m16Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    m16Texture = [self loadImageTexture : device : (void*)[m16 bytes] : [m16 length]];
    
    NSData *m24 = [[NSData alloc] initWithBase64EncodedString:m24Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    m24Texture = [self loadImageTexture : device : (void*)[m24 bytes] : [m24 length]];
    
    NSData *m249 = [[NSData alloc] initWithBase64EncodedString:m249Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    m249Texture = [self loadImageTexture : device : (void*)[m249 bytes] : [m249 length]];
    
    NSData *m762 = [[NSData alloc] initWithBase64EncodedString:m762Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    m762Texture = [self loadImageTexture : device : (void*)[m762 bytes] : [m762 length]];
    
    NSData *mg3 = [[NSData alloc] initWithBase64EncodedString:mg3Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    mg3Texture = [self loadImageTexture : device : (void*)[mg3 bytes] : [mg3 length]];
    
    NSData *mini = [[NSData alloc] initWithBase64EncodedString:miniBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    miniTexture = [self loadImageTexture : device : (void*)[mini bytes] : [mini length]];
    
    NSData *mk14 = [[NSData alloc] initWithBase64EncodedString:mk14Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    mk14Texture = [self loadImageTexture : device : (void*)[mk14 bytes] : [mk14 length]];
    
    NSData *mk47 = [[NSData alloc] initWithBase64EncodedString:mk47Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    mk47Texture = [self loadImageTexture : device : (void*)[mk47 bytes] : [mk47 length]];
    
    NSData *scar = [[NSData alloc] initWithBase64EncodedString:scarBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    scarTexture = [self loadImageTexture : device : (void*)[scar bytes] : [scar length]];
    
    NSData *slr = [[NSData alloc] initWithBase64EncodedString:slrBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    slrTexture = [self loadImageTexture : device : (void*)[slr bytes] : [slr length]];
    
    NSData *awm = [[NSData alloc] initWithBase64EncodedString:awmBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    awmTexture = [self loadImageTexture : device : (void*)[awm bytes] : [awm length]];
    
    NSData *dp28 = [[NSData alloc] initWithBase64EncodedString:dp28Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    dp28Texture = [self loadImageTexture : device : (void*)[dp28 bytes] : [dp28 length]];
    
    NSData *k98 = [[NSData alloc] initWithBase64EncodedString:k98Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    k98Texture = [self loadImageTexture : device : (void*)[k98 bytes] : [k98 length]];
    
    NSData *vss = [[NSData alloc] initWithBase64EncodedString:vssBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    vssTexture = [self loadImageTexture : device : (void*)[vss bytes] : [vss length]];
    
    NSData *sks = [[NSData alloc] initWithBase64EncodedString:sksBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    sksTexture = [self loadImageTexture : device : (void*)[sks bytes] : [sks length]];
    
    NSData *hz = [[NSData alloc] initWithBase64EncodedString:hzBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    hzTexture = [self loadImageTexture : device : (void*)[hz bytes] : [hz length]];
    
    
    NSData *yl = [[NSData alloc] initWithBase64EncodedString:ylBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    ylTexture = [self loadImageTexture : device : (void*)[yl bytes] : [yl length]];

    NSData *jjb = [[NSData alloc] initWithBase64EncodedString:jjbBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    jjbTexture = [self loadImageTexture : device : (void*)[jjb bytes] : [jjb length]];
    
    NSData *zty = [[NSData alloc] initWithBase64EncodedString:ztyBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    ztyTexture = [self loadImageTexture : device : (void*)[zty bytes] : [zty length]];
    
    NSData *zhen = [[NSData alloc] initWithBase64EncodedString:zhenBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    zhenTexture = [self loadImageTexture : device : (void*)[zhen bytes] : [zhen length]];
    
    NSData *ylx = [[NSData alloc] initWithBase64EncodedString:ylxBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    ylxTexture = [self loadImageTexture : device : (void*)[ylx bytes] : [ylx length]];
    
    NSData *b4 = [[NSData alloc] initWithBase64EncodedString:b4Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    b4Texture = [self loadImageTexture : device : (void*)[b4 bytes] : [b4 length]];

    NSData *b3 = [[NSData alloc] initWithBase64EncodedString:b3Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    b3Texture = [self loadImageTexture : device : (void*)[b3 bytes] : [b3 length]];

    NSData *b6 = [[NSData alloc] initWithBase64EncodedString:b6Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    b6Texture = [self loadImageTexture : device : (void*)[b6 bytes] : [b6 length]];

    NSData *b8 = [[NSData alloc] initWithBase64EncodedString:b8Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    b8Texture = [self loadImageTexture : device : (void*)[b8 bytes] : [b8 length]];

    NSData *kt = [[NSData alloc] initWithBase64EncodedString:ktBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    ktTexture = [self loadImageTexture : device : (void*)[kt bytes] : [kt length]];

    NSData *t3 = [[NSData alloc] initWithBase64EncodedString:t3Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    t3Texture = [self loadImageTexture : device : (void*)[t3 bytes] : [t3 length]];

    NSData *j3 = [[NSData alloc] initWithBase64EncodedString:j3Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    j3Texture = [self loadImageTexture : device : (void*)[j3 bytes] : [j3 length]];

    NSData *bb3 = [[NSData alloc] initWithBase64EncodedString:bb3Base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    bb3Texture = [self loadImageTexture : device : (void*)[bb3 bytes] : [bb3 length]];

    NSData *tlei = [[NSData alloc] initWithBase64EncodedString:tleiBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    tleiTexture = [self loadImageTexture : device : (void*)[tlei bytes] : [tlei length]];

    NSData *tyan = [[NSData alloc] initWithBase64EncodedString:tyanBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    tyanTexture = [self loadImageTexture : device : (void*)[tyan bytes] : [tyan length]];

    NSData *thuo = [[NSData alloc] initWithBase64EncodedString:thuoBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    thuoTexture = [self loadImageTexture : device : (void*)[thuo bytes] : [thuo length]];

    NSData *leizha = [[NSData alloc] initWithBase64EncodedString:leizhaBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    leizhaTexture = [self loadImageTexture : device : (void*)[leizha bytes] : [leizha length]];

    NSData *hongzha = [[NSData alloc] initWithBase64EncodedString:hongzhaBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    hongzhaTexture = [self loadImageTexture : device : (void*)[hongzha bytes] : [hongzha length]];

    NSData *sld = [[NSData alloc] initWithBase64EncodedString:sldBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    sldTexture = [self loadImageTexture : device : (void*)[sld bytes] : [sld length]];

    NSData *ywd = [[NSData alloc] initWithBase64EncodedString:ywdBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    ywdTexture = [self loadImageTexture : device : (void*)[ywd bytes] : [ywd length]];

    NSData *rsp = [[NSData alloc] initWithBase64EncodedString:rspBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    rspTexture = [self loadImageTexture : device : (void*)[rsp bytes] : [rsp length]];


}

-(id<MTLTexture>)loadImageTexture:(id<MTLDevice>)device :(void*) imageData :(size_t) fileDataSize {
    int width, height;
    unsigned char *pixels = stbi_load_from_memory((stbi_uc const *)imageData, (int)fileDataSize, &width, &height, NULL, 4);

    MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm
                                                                                                 width:(NSUInteger)width
                                                                                                height:(NSUInteger)height
                                                                                             mipmapped:NO];
    textureDescriptor.usage = MTLTextureUsageShaderRead;
    textureDescriptor.storageMode = MTLStorageModeShared;
    id<MTLTexture> texture = [device newTextureWithDescriptor:textureDescriptor];
    [texture replaceRegion:MTLRegionMake2D(0, 0, (NSUInteger)width, (NSUInteger)height) mipmapLevel:0 withBytes:pixels bytesPerRow:(NSUInteger)width * 4];
    
    return texture;
}


@end
