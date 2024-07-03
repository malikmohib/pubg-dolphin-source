//
//  MenuWindow.m
//  Dolphins
//
//  Created by XBK on 2022/4/25.
//

#import "MenuWindow.h"
#import "OverlayView.h"
@implementation MenuWindow


INI* config;


const char *optionItemName[] = {"系统信息", "人物绘制", "物品绘制", "自动瞄准"};
int optionItemCurrent = 0;
//自瞄部位文本
int aimbotIntensity;
const char *aimbotIntensityText[] = {"微","低", "中", "高", "超高", "强锁", "锁死"};
//自瞄部位文本
const char *aimbotModeText[] = {"开镜启动", "开火启动", "开镜开火启动", "自动模式启动", "触摸位置启动"};
//自瞄部位文本
const char *aimbotPartsText[] = {"优先头部(漏打)", "优先身体(漏打)", "自动模式(漏打)", "固定头部", "固定身体"};

OverlayView *overlayView;

- (instancetype)initWithFrame:(ModuleControl*)control {
    self.moduleControl = control;
    //获取Documents目录路径
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //初始化文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //拼接文件路径
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"dolphins.ini"];
    //文件不存在
    if(![fileManager fileExistsAtPath:filePath]){
        //创建文件
        [fileManager createFileAtPath:filePath contents:[NSData data] attributes:nil];
    }
    //获取ini文件数据
    config = ini_load((char*)filePath.UTF8String);
    
    return [super init];
}

-(void)setOverlayView:(OverlayView*)ov{
    overlayView = ov;
    //读配置项
    [self readIniConfig];
}

-(void)drawMenuWindow {
    //设置下一个窗口的大小
    ImGuiIO & io = ImGui::GetIO();
    ImGui::SetNextWindowSize({1280, 700}, ImGuiCond_FirstUseEver);
//    ImGui::SetNextWindowPos({172, 172}, ImGuiCond_FirstUseEver);
    ImGui::SetNextWindowPos(ImVec2(io.DisplaySize.x * 0.5f, io.DisplaySize.y * 0.5f), 0, ImVec2(0.5f, 0.5f));  //居中处理;
    //窗口
     if (ImGui::Begin("X.洗衣液 - 宇宙: 【QQ:1599202925】NIKE ",&self.moduleControl->menuStatus, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize)) {
        ImGuiContext& g = *GImGui;
        if(g.NavWindow == NULL){
            self.moduleControl->menuStatus = !self.moduleControl->menuStatus;
        }
        //设置下一个控件的宽度
        ImGui::BeginChild("##optionLayout", {calcTextSize("选项布局") + 32.0f, 0}, false, ImGuiWindowFlags_None);
        for (int i = 0; i < 4; ++i) {
            if (optionItemCurrent != i) {
                ImGui::PushStyleColor(ImGuiCol_Button, ImColor(0, 0, 0, 0).Value);
                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImColor(0, 0, 0, 0).Value);
                ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImColor(0, 0, 0, 0).Value);
            }
            bool isClick = ImGui::Button(optionItemName[i]);
            if (optionItemCurrent != i) {
                ImGui::PopStyleColor(3);
            }
            if (isClick) {
                optionItemCurrent = i;
            }
        }
        ImGui::EndChild();
        //同一行
        ImGui::SameLine();
        ImGui::BeginChild("##surfaceLayout", {0, 0}, false, ImGuiWindowFlags_None);
        switch (optionItemCurrent) {
            case 0:
                [self showSystemInfo];
                break;
            case 1:
                [self showPlayerControl];
                break;
            case 2:
                [self showMaterialControl];
                break;
            case 3:
                [self showAimbotControl];
                break;
        }
        ImGui::EndChild();
        
        
        ImGui::End();
    }
}


-(void)showSystemInfo {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "绘制帧率");
    if (ImGui::RadioButton("60FPS", &self.moduleControl->fps, 0)) {
        configManager::putInteger(config,"mainSwitch", "fps",self.moduleControl->fps);
        overlayView.preferredFramesPerSecond = 60;
    }
    ImGui::SameLine();
    if (ImGui::RadioButton("90FPS", &self.moduleControl->fps, 1)) {
        configManager::putInteger(config,"mainSwitch", "fps",self.moduleControl->fps);
        overlayView.preferredFramesPerSecond = 90;
    }
    ImGui::SameLine();
    if (ImGui::RadioButton("120FPS", &self.moduleControl->fps, 2)) {
        configManager::putInteger(config,"mainSwitch", "fps",self.moduleControl->fps);
        overlayView.preferredFramesPerSecond = 120;
    }
    
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "控制开关");
    
    if (ImGui::Checkbox("人物透视", &self.moduleControl->mainSwitch.playerStatus)) {
        configManager::putBoolean(config,"mainSwitch", "player", self.moduleControl->mainSwitch.playerStatus);
           }
    ImGui::SameLine();
    if (ImGui::Checkbox("物资透视", &self.moduleControl->mainSwitch.materialStatus)) {
        configManager::putBoolean(config,"mainSwitch", "material", self.moduleControl->mainSwitch.materialStatus);
        }
    ImGui::SameLine();
    if (ImGui::Checkbox("辅助瞄准", &self.moduleControl->mainSwitch.aimbotStatus)) {
        configManager::putBoolean(config,"mainSwitch", "aimbot", self.moduleControl->mainSwitch.aimbotStatus);
            }
    
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "系统公告");
    
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(32.0f, 32.0f));
    ImGui::TextWrapped("%s", "星巴克出品绘制自瞄裸奔版本,禁止买卖仅供娱乐\n最终解释权归星巴克所有");
    ImGui::PopStyleVar();
    
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "系统信息");
    
    ImGui::Text("绘制延迟[ %.1fMs / %.1fFps ]", 1000 / ImGui::GetIO().Framerate, ImGui::GetIO().Framerate);
    
}

-(void) showPlayerControl {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "人物绘制");
    if (ImGui::Checkbox("手持贴图", &self.moduleControl->playerSwitch.SCStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_6", self.moduleControl->playerSwitch.SCStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("手持文字", &self.moduleControl->playerSwitch.SCWZStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_7", self.moduleControl->playerSwitch.SCWZStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("物资贴图", &self.moduleControl->playerSwitch.WZStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_8", self.moduleControl->playerSwitch.WZStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("物资文字", &self.moduleControl->playerSwitch.WZWZStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_9", self.moduleControl->playerSwitch.WZWZStatus);
    }
    
    if (ImGui::Checkbox("人物方框", &self.moduleControl->playerSwitch.boxStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_0", self.moduleControl->playerSwitch.boxStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("人物骨骼", &self.moduleControl->playerSwitch.boneStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_1", self.moduleControl->playerSwitch.boneStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("人物天线", &self.moduleControl->playerSwitch.lineStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_2", self.moduleControl->playerSwitch.lineStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("人物信息", &self.moduleControl->playerSwitch.infoStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_3", self.moduleControl->playerSwitch.infoStatus);
    }
    
    if (ImGui::Checkbox("雷达预警", &self.moduleControl->playerSwitch.radarStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_4", self.moduleControl->playerSwitch.radarStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("背后预警", &self.moduleControl->playerSwitch.backStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_5", self.moduleControl->playerSwitch.backStatus);
    }
    
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "雷达调整");
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("雷达X") - 32.0f);
    if (ImGui::SliderFloat("雷达X##radarX", &self.moduleControl->playerSwitch.radarCoord.x, 0.0f, ([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].nativeScale), "%.0f")) {
        configManager::putFloat(config,"playerSwitch", "radarX", self.moduleControl->playerSwitch.radarCoord.x);
    }
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("雷达Y") - 32.0f);
    if (ImGui::SliderFloat("雷达Y##radarY", &self.moduleControl->playerSwitch.radarCoord.y, 0.0f, ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale), "%.0f")) {
        configManager::putFloat(config,"playerSwitch", "radarY", self.moduleControl->playerSwitch.radarCoord.y);
    }
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("雷达大小") - 32.0f);
    if (ImGui::SliderFloat("雷达大小##radarSize", &self.moduleControl->playerSwitch.radarSize, 1.0f, 100, "%.0f%%")) {
        configManager::putFloat(config,"playerSwitch", "radarSize", self.moduleControl->playerSwitch.radarSize);
    }
}

-(void) showMaterialControl {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "物品绘制");
    
    if (ImGui::Checkbox("载具", &self.moduleControl->materialSwitch[Vehicle])) {
        std::string str = "materialSwitch_" + std::to_string(Vehicle);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Vehicle]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("空头Or盒子", &self.moduleControl->materialSwitch[Airdrop])) {
        std::string str = "materialSwitch_" + std::to_string(Airdrop);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Airdrop]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("信号枪", &self.moduleControl->materialSwitch[FlareGun])) {
        std::string str = "materialSwitch_" + std::to_string(FlareGun);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[FlareGun]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("狙击枪", &self.moduleControl->materialSwitch[Sniper])) {
        std::string str = "materialSwitch_" + std::to_string(Sniper);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Sniper]);
    }
    
    if (ImGui::Checkbox("步枪", &self.moduleControl->materialSwitch[Rifle])) {
        std::string str = "materialSwitch_" + std::to_string(Rifle);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Rifle]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("投掷物", &self.moduleControl->materialSwitch[Missile])) {
        std::string str = "materialSwitch_" + std::to_string(Missile);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Missile]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("防具Or背包", &self.moduleControl->materialSwitch[Armor])) {
        std::string str = "materialSwitch_" + std::to_string(Armor);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Armor]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("狙击枪配件", &self.moduleControl->materialSwitch[SniperParts])) {
        std::string str = "materialSwitch_" + std::to_string(SniperParts);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[SniperParts]);
    }
    
    if (ImGui::Checkbox("步枪配件", &self.moduleControl->materialSwitch[RifleParts])) {
        std::string str = "materialSwitch_" + std::to_string(RifleParts);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[RifleParts]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("药品", &self.moduleControl->materialSwitch[Drug])) {
        std::string str = "materialSwitch_" + std::to_string(Drug);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Drug]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("子弹", &self.moduleControl->materialSwitch[Bullet])) {
        std::string str = "materialSwitch_" + std::to_string(Bullet);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Bullet]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("握把", &self.moduleControl->materialSwitch[Grip])) {
        std::string str = "materialSwitch_" + std::to_string(Grip);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Grip]);
    }
    
    if (ImGui::Checkbox("瞄准镜", &self.moduleControl->materialSwitch[Sight])) {
        std::string str = "materialSwitch_" + std::to_string(Sight);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Sight]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("手雷预警", &self.moduleControl->materialSwitch[Warning])) {
        std::string str = "materialSwitch_" + std::to_string(Warning);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Warning]);
    }
}

-(void) showAimbotControl {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "自动瞄准");
    
    ImGui::SetNextItemWidth(calcTextSize("自瞄强度占位"));
    if (ImGui::Combo("自瞄强度", &aimbotIntensity, aimbotIntensityText, IM_ARRAYSIZE(aimbotIntensityText))) {
        configManager::putInteger(config,"aimbotControl", "intensity",aimbotIntensity);
        switch (aimbotIntensity) {
            case 0:
                self.moduleControl->aimbotController.aimbotIntensity = 0.1f;
                break;
            case 1:
                self.moduleControl->aimbotController.aimbotIntensity = 0.2f;
                break;
            case 2:
                self.moduleControl->aimbotController.aimbotIntensity = 0.3f;
                break;
            case 3:
                self.moduleControl->aimbotController.aimbotIntensity = 0.4f;
                break;
            case 4:
                self.moduleControl->aimbotController.aimbotIntensity = 0.5f;
                break;
            case 5:
                self.moduleControl->aimbotController.aimbotIntensity = 1.0f;
                break;
            case 6:
                self.moduleControl->aimbotController.aimbotIntensity = 1.2f;
                break;
        }
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("显示自瞄范围", &self.moduleControl->aimbotController.showAimbotRadius)) {
        configManager::putBoolean(config,"aimbotControl", "showRadius", self.moduleControl->aimbotController.showAimbotRadius);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("倒地不瞄", &self.moduleControl->aimbotController.fallNotAim)) {
        configManager::putBoolean(config,"aimbotControl", "fall", self.moduleControl->aimbotController.fallNotAim);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("烟雾内不瞄", &self.moduleControl->aimbotController.smoke)) {
        configManager::putBoolean(config,"aimbotControl", "smoke", self.moduleControl->aimbotController.smoke);
    }
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() / 2 - calcTextSize("自瞄模式") - 32.0f);
    if (ImGui::Combo("自瞄模式", &self.moduleControl->aimbotController.aimbotMode, aimbotModeText, IM_ARRAYSIZE(aimbotModeText))) {
        configManager::putInteger(config,"aimbotControl", "mode", self.moduleControl->aimbotController.aimbotMode);
    }
    ImGui::SameLine();
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() / 2 - calcTextSize("自瞄部位") - 32.0f);
    if (ImGui::Combo("自瞄部位", &self.moduleControl->aimbotController.aimbotParts, aimbotPartsText, IM_ARRAYSIZE(aimbotPartsText))) {
        configManager::putBoolean(config,"aimbotControl", "parts", self.moduleControl->aimbotController.aimbotParts);
    }
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("自瞄范围") - 32.0f);
    if (ImGui::SliderFloat("自瞄范围", &self.moduleControl->aimbotController.aimbotRadius, 0.0f, ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale) / 2, "%.0f")) {
        configManager::putFloat(config,"aimbotControl", "radius", self.moduleControl->aimbotController.aimbotRadius);
    }
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("自瞄距离限制") - 32.0f);
    if (ImGui::SliderFloat("自瞄距离限制", &self.moduleControl->aimbotController.distance, 0.0f, 450.0f, "%.0fM")) {
        configManager::putFloat(config,"aimbotControl", "distance", self.moduleControl->aimbotController.distance);
    }
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "自瞄说明");
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(32.0f, 32.0f));
    ImGui::TextWrapped( "自动模式启动：单发枪为开镜自瞄，连发枪为开火自瞄\n自动模式部位：单发枪打头，连发枪打胸");
    ImGui::PopStyleVar();
}

-(void)readIniConfig{
    self.moduleControl->fps = configManager::readInteger(config,"mainSwitch", "fps", 0);
    switch(self.moduleControl->fps){
        case 0:
            overlayView.preferredFramesPerSecond = 60;
            break;
        case 1:
            overlayView.preferredFramesPerSecond = 90;
            break;
        case 2:
            overlayView.preferredFramesPerSecond = 120;
            break;
        default:
            overlayView.preferredFramesPerSecond = 120;
            break;
    }
    //主开关
    self.moduleControl->mainSwitch.playerStatus = configManager::readBoolean(config,"mainSwitch", "player", false);
    self.moduleControl->mainSwitch.materialStatus = configManager::readBoolean(config,"mainSwitch", "material", false);
    self.moduleControl->mainSwitch.aimbotStatus = configManager::readBoolean(config,"mainSwitch", "aimbot", false);
    //人物开关
    for (int i = 0; i < 10; ++i) {
        std::string str = "playerSwitch_" + std::to_string(i);
        *((bool *) &self.moduleControl->playerSwitch + sizeof(bool) * i) = configManager::readBoolean(config,"playerSwitch", str.c_str(), false);
    }
    //雷达坐标
    self.moduleControl->playerSwitch.radarSize = configManager::readFloat(config,"playerSwitch", "radarSize", 70);
    self.moduleControl->playerSwitch.radarCoord.x = configManager::readFloat(config,"playerSwitch", "radarX", 500);
    self.moduleControl->playerSwitch.radarCoord.y = configManager::readFloat(config,"playerSwitch", "radarY", 500);
    //物资开关
    for (int i = 0; i < All; ++i) {
        std::string str = "materialSwitch_" + std::to_string(i);
        self.moduleControl->materialSwitch[i] = configManager::readBoolean(config,"materialSwitch", str.c_str(), false);
    }
    //倒地不瞄
    self.moduleControl->aimbotController.fallNotAim = configManager::readBoolean(config,"aimbotControl", "fall", false);
    self.moduleControl->aimbotController.showAimbotRadius = configManager::readBoolean(config,"aimbotControl", "showRadius", true);
    self.moduleControl->aimbotController.aimbotRadius = configManager::readFloat(config,"aimbotControl", "radius", 320);
    
    self.moduleControl->aimbotController.smoke = configManager::readBoolean(config,"aimbotControl", "smoke", true);
    
    //自瞄模式
    self.moduleControl->aimbotController.aimbotMode = configManager::readInteger(config,"aimbotControl", "mode", 3);
    //自瞄部位
    self.moduleControl->aimbotController.aimbotParts = configManager::readInteger(config,"aimbotControl", "parts", 2);
    //自瞄强度
    aimbotIntensity = configManager::readInteger(config,"aimbotControl", "intensity", 2);
    switch (aimbotIntensity) {
        case 0:
            self.moduleControl->aimbotController.aimbotIntensity = 0.1f;
            break;
        case 1:
            self.moduleControl->aimbotController.aimbotIntensity = 0.2f;
            break;
        case 2:
            self.moduleControl->aimbotController.aimbotIntensity = 0.3f;
            break;
        case 3:
            self.moduleControl->aimbotController.aimbotIntensity = 0.4f;
            break;
        case 4:
            self.moduleControl->aimbotController.aimbotIntensity = 0.5f;
            break;
        case 5:
            self.moduleControl->aimbotController.aimbotIntensity = 1.0f;
            break;
        case 6:
            self.moduleControl->aimbotController.aimbotIntensity = 1.2f;
            break;
    }
    //自瞄距离
    self.moduleControl->aimbotController.distance = configManager::readFloat(config,"aimbotControl", "distance", 450);
}

@end
