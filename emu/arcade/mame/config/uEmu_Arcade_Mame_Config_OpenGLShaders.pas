unit uEmu_Arcade_Mame_Config_OpenGLShaders;

interface
uses
  System.Classes,
  System.UITypes,
  System.SysUtils,
  FMX.StdCtrls,
  FMX.Types,
  FMX.Edit,
  FMX.Listbox,
  FMX.Dialogs;

  procedure uEmu_Arcade_Mame_Config_Create_OpenGL_Shaders_Panel;

  procedure uEmu_Arcade_Mame_Config_OpenGL_Shaders_ButtonClick(vName: String);
  procedure uEmu_Arcade_Mame_Config_OpenGL_Shaders_OpenDialog;

implementation
uses
  uEmu_Arcade_Mame_AllTypes;

procedure uEmu_Arcade_Mame_Config_Create_OpenGL_Shaders_Panel;
begin
  vMame.Config.Panel.OGL_Shaders.OpenDialog:= TOpenDialog.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.OpenDialog.Name:= 'Mame_OpenGL_Shaders_OpenDialog';
  vMame.Config.Panel.OGL_Shaders.OpenDialog.Filter:= 'Chains (*.json)|*.json';
  vMame.Config.Panel.OGL_Shaders.OpenDialog.OnClose:= mame.Config.Input.Mouse.OpenDialog.OnClose;

  vMame.Config.Panel.OGL_Shaders.Labels[0]:= TLabel.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Labels[0].Name:= 'Mame_OpenGLShaders_InfoLabel_1';
  vMame.Config.Panel.OGL_Shaders.Labels[0].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Labels[0].TextSettings.HorzAlign:= TTextAlign.Trailing;
  vMame.Config.Panel.OGL_Shaders.Labels[0].Text:= 'Global Options';
  vMame.Config.Panel.OGL_Shaders.Labels[0].Position.Y:= 5;
  vMame.Config.Panel.OGL_Shaders.Labels[0].Position.X:= vMame.Config.Scene.Right_Panels[5].Width- vMame.Config.Panel.OGL_Shaders.Labels[0].Width- 10;
  vMame.Config.Panel.OGL_Shaders.Labels[0].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Labels[1]:= TLabel.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Labels[1].Name:= 'Mame_OpenGLShaders_InfoLabel_2';
  vMame.Config.Panel.OGL_Shaders.Labels[1].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Labels[1].TextSettings.HorzAlign:= TTextAlign.Trailing;
  vMame.Config.Panel.OGL_Shaders.Labels[1].Text:= 'Default options used by all games';
  vMame.Config.Panel.OGL_Shaders.Labels[1].Width:= 180;
  vMame.Config.Panel.OGL_Shaders.Labels[1].Position.Y:= 22;
  vMame.Config.Panel.OGL_Shaders.Labels[1].Position.X:= vMame.Config.Scene.Right_Panels[5].Width- vMame.Config.Panel.OGL_Shaders.Labels[1].Width- 10;
  vMame.Config.Panel.OGL_Shaders.Labels[1].Visible:= True;

  //left
  vMame.Config.Panel.OGL_Shaders.Groupbox[0]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Groupbox[0].Name:= 'Mame_OpenGLShaders_Groupbox_MameShader0';
  vMame.Config.Panel.OGL_Shaders.Groupbox[0].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Groupbox[0].SetBounds(10,40,((vMame.Config.Scene.Right_Panels[5].Width/ 2)- 15),90);
  vMame.Config.Panel.OGL_Shaders.Groupbox[0].Text:= 'MAME shader 0';
  vMame.Config.Panel.OGL_Shaders.Groupbox[0].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Edit[0]:= TEdit.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[0]);
  vMame.Config.Panel.OGL_Shaders.Edit[0].Name:= 'Mame_OpenGLShaders_Edit_MameShader0';
  vMame.Config.Panel.OGL_Shaders.Edit[0].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[0];
  vMame.Config.Panel.OGL_Shaders.Edit[0].SetBounds(5,30,(vMame.Config.Panel.OGL_Shaders.Groupbox[0].Width- 10),20);
  vMame.Config.Panel.OGL_Shaders.Edit[0].Text:= mame.Emu.Ini.OpenGL_glsl_shader_mame0;
  vMame.Config.Panel.OGL_Shaders.Edit[0].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[0]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[0]);
  vMame.Config.Panel.OGL_Shaders.Button[0].Name:= 'Mame_OpenGLShaders_Button_MameShader0_Select';
  vMame.Config.Panel.OGL_Shaders.Button[0].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[0];
  vMame.Config.Panel.OGL_Shaders.Button[0].SetBounds(10,60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[0].Width:= 80;
  vMame.Config.Panel.OGL_Shaders.Button[0].Height:= 20;
  vMame.Config.Panel.OGL_Shaders.Button[0].Text:= 'Select';
  vMame.Config.Panel.OGL_Shaders.Button[0].Position.X:= 10;
  vMame.Config.Panel.OGL_Shaders.Button[0].Position.Y:= 60;
  vMame.Config.Panel.OGL_Shaders.Button[0].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[0].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[1]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[0]);
  vMame.Config.Panel.OGL_Shaders.Button[1].Name:= 'Mame_OpenGLShaders_Button_MameShader0_Reset';
  vMame.Config.Panel.OGL_Shaders.Button[1].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[0];
  vMame.Config.Panel.OGL_Shaders.Button[1].SetBounds((vMame.Config.Panel.OGL_Shaders.Groupbox[0].Width- 90),60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[1].Text:= 'Reset';
  vMame.Config.Panel.OGL_Shaders.Button[1].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[1].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Groupbox[1]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Groupbox[1].Name:= 'Mame_OpenGLShaders_Groupbox_MameShader1';
  vMame.Config.Panel.OGL_Shaders.Groupbox[1].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Groupbox[1].SetBounds(10,135,((vMame.Config.Scene.Right_Panels[5].Width/ 2)- 15),90);
  vMame.Config.Panel.OGL_Shaders.Groupbox[1].Text:= 'MAME shader 1';
  vMame.Config.Panel.OGL_Shaders.Groupbox[1].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Edit[1]:= TEdit.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[1]);
  vMame.Config.Panel.OGL_Shaders.Edit[1].Name:= 'Mame_OpenGLShaders_Edit_MameShader1';
  vMame.Config.Panel.OGL_Shaders.Edit[1].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[1];
  vMame.Config.Panel.OGL_Shaders.Edit[1].SetBounds(5,30,(vMame.Config.Panel.OGL_Shaders.Groupbox[1].Width- 10),20);
  vMame.Config.Panel.OGL_Shaders.Edit[1].Text:= mame.Emu.Ini.OpenGL_glsl_shader_mame1;
  vMame.Config.Panel.OGL_Shaders.Edit[1].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[2]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[1]);
  vMame.Config.Panel.OGL_Shaders.Button[2].Name:= 'Mame_OpenGLShaders_Button_MameShader1_Select';
  vMame.Config.Panel.OGL_Shaders.Button[2].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[1];
  vMame.Config.Panel.OGL_Shaders.Button[2].SetBounds(10,60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[2].Text:= 'Select';
  vMame.Config.Panel.OGL_Shaders.Button[2].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[2].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[3]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[1]);
  vMame.Config.Panel.OGL_Shaders.Button[3].Name:= 'Mame_OpenGLShaders_Button_MameShader1_Reset';
  vMame.Config.Panel.OGL_Shaders.Button[3].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[1];
  vMame.Config.Panel.OGL_Shaders.Button[3].SetBounds((vMame.Config.Panel.OGL_Shaders.Groupbox[1].Width- 90),60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[3].Text:= 'Reset';
  vMame.Config.Panel.OGL_Shaders.Button[3].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[3].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Groupbox[2]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Groupbox[2].Name:= 'Mame_OpenGLShaders_Groupbox_MameShader2';
  vMame.Config.Panel.OGL_Shaders.Groupbox[2].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Groupbox[2].SetBounds(10,230,((vMame.Config.Scene.Right_Panels[5].Width/ 2)- 15),90);
  vMame.Config.Panel.OGL_Shaders.Groupbox[2].Text:= 'MAME shader 2';
  vMame.Config.Panel.OGL_Shaders.Groupbox[2].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Edit[2]:= TEdit.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[2]);
  vMame.Config.Panel.OGL_Shaders.Edit[2].Name:= 'Mame_OpenGLShaders_Edit_MameShader2';
  vMame.Config.Panel.OGL_Shaders.Edit[2].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[2];
  vMame.Config.Panel.OGL_Shaders.Edit[2].SetBounds(5,30,(vMame.Config.Panel.OGL_Shaders.Groupbox[2].Width- 10),20);
  vMame.Config.Panel.OGL_Shaders.Edit[2].Text:= mame.Emu.Ini.OpenGL_glsl_shader_mame2;
  vMame.Config.Panel.OGL_Shaders.Edit[2].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[4]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[2]);
  vMame.Config.Panel.OGL_Shaders.Button[4].Name:= 'Mame_OpenGLShaders_Button_MameShader2_Select';
  vMame.Config.Panel.OGL_Shaders.Button[4].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[2];
  vMame.Config.Panel.OGL_Shaders.Button[4].SetBounds(10,60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[4].Text:= 'Select';
  vMame.Config.Panel.OGL_Shaders.Button[4].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[4].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[5]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[2]);
  vMame.Config.Panel.OGL_Shaders.Button[5].Name:= 'Mame_OpenGLShaders_Button_MameShader2_Reset';
  vMame.Config.Panel.OGL_Shaders.Button[5].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[2];
  vMame.Config.Panel.OGL_Shaders.Button[5].SetBounds((vMame.Config.Panel.OGL_Shaders.Groupbox[2].Width- 90),60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[5].Text:= 'Reset';
  vMame.Config.Panel.OGL_Shaders.Button[5].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[5].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Groupbox[3]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Groupbox[3].Name:= 'Mame_OpenGLShaders_Groupbox_MameShader3';
  vMame.Config.Panel.OGL_Shaders.Groupbox[3].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Groupbox[3].SetBounds(10,325,((vMame.Config.Scene.Right_Panels[5].Width/ 2)- 15),90);
  vMame.Config.Panel.OGL_Shaders.Groupbox[3].Text:= 'MAME shader 3';
  vMame.Config.Panel.OGL_Shaders.Groupbox[3].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Edit[3]:= TEdit.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[3]);
  vMame.Config.Panel.OGL_Shaders.Edit[3].Name:= 'Mame_OpenGLShaders_Edit_MameShader3';
  vMame.Config.Panel.OGL_Shaders.Edit[3].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[3];
  vMame.Config.Panel.OGL_Shaders.Edit[3].SetBounds(5,30,(vMame.Config.Panel.OGL_Shaders.Groupbox[3].Width- 10),20);
  vMame.Config.Panel.OGL_Shaders.Edit[3].Text:= mame.Emu.Ini.OpenGL_glsl_shader_mame3;
  vMame.Config.Panel.OGL_Shaders.Edit[3].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[6]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[3]);
  vMame.Config.Panel.OGL_Shaders.Button[6].Name:= 'Mame_OpenGLShaders_Button_MameShader3_Select';
  vMame.Config.Panel.OGL_Shaders.Button[6].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[3];
  vMame.Config.Panel.OGL_Shaders.Button[6].SetBounds(10,60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[6].Text:= 'Select';
  vMame.Config.Panel.OGL_Shaders.Button[6].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[6].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[7]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[3]);
  vMame.Config.Panel.OGL_Shaders.Button[7].Name:= 'Mame_OpenGLShaders_Button_MameShader3_Reset';
  vMame.Config.Panel.OGL_Shaders.Button[7].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[3];
  vMame.Config.Panel.OGL_Shaders.Button[7].SetBounds((vMame.Config.Panel.OGL_Shaders.Groupbox[3].Width- 90),60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[7].Text:= 'Reset';
  vMame.Config.Panel.OGL_Shaders.Button[7].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[7].Visible:= True;

  //right
  vMame.Config.Panel.OGL_Shaders.Groupbox[4]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Groupbox[4].Name:= 'Mame_OpenGLShaders_Groupbox_ScreenShader0';
  vMame.Config.Panel.OGL_Shaders.Groupbox[4].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Groupbox[4].SetBounds(((vMame.Config.Scene.Right_Panels[5].Width/ 2)+ 5),40,((vMame.Config.Scene.Right_Panels[5].Width/ 2)- 15),90);
  vMame.Config.Panel.OGL_Shaders.Groupbox[4].Text:= 'Screen shader 0';
  vMame.Config.Panel.OGL_Shaders.Groupbox[4].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Edit[4]:= TEdit.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[4]);
  vMame.Config.Panel.OGL_Shaders.Edit[4].Name:= 'Mame_OpenGLShaders_Edit_ScreenShader0';
  vMame.Config.Panel.OGL_Shaders.Edit[4].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[4];
  vMame.Config.Panel.OGL_Shaders.Edit[4].SetBounds(5,30,(vMame.Config.Panel.OGL_Shaders.Groupbox[4].Width- 10),20);
  vMame.Config.Panel.OGL_Shaders.Edit[4].Text:= mame.Emu.Ini.OpenGL_glsl_shader_screen0;
  vMame.Config.Panel.OGL_Shaders.Edit[4].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[8]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[4]);
  vMame.Config.Panel.OGL_Shaders.Button[8].Name:= 'Mame_OpenGLShaders_Button_ScreenShader0_Select';
  vMame.Config.Panel.OGL_Shaders.Button[8].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[4];
  vMame.Config.Panel.OGL_Shaders.Button[8].SetBounds(10,60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[8].Text:= 'Select';
  vMame.Config.Panel.OGL_Shaders.Button[8].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[8].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[9]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[4]);
  vMame.Config.Panel.OGL_Shaders.Button[9].Name:= 'Mame_OpenGLShaders_Button_ScreenShader0_Reset';
  vMame.Config.Panel.OGL_Shaders.Button[9].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[4];
  vMame.Config.Panel.OGL_Shaders.Button[9].SetBounds((vMame.Config.Panel.OGL_Shaders.Groupbox[4].Width- 90),60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[9].Text:= 'Reset';
  vMame.Config.Panel.OGL_Shaders.Button[9].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[9].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Groupbox[5]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Groupbox[5].Name:= 'Mame_OpenGLShaders_Groupbox_ScreenShader1';
  vMame.Config.Panel.OGL_Shaders.Groupbox[5].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Groupbox[5].SetBounds(((vMame.Config.Scene.Right_Panels[5].Width/ 2)+ 5),135,((vMame.Config.Scene.Right_Panels[5].Width/ 2)- 15),90);
  vMame.Config.Panel.OGL_Shaders.Groupbox[5].Text:= 'Screen shader 1';
  vMame.Config.Panel.OGL_Shaders.Groupbox[5].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Edit[5]:= TEdit.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[5]);
  vMame.Config.Panel.OGL_Shaders.Edit[5].Name:= 'Mame_OpenGLShaders_Edit_ScreenShader1';
  vMame.Config.Panel.OGL_Shaders.Edit[5].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[5];
  vMame.Config.Panel.OGL_Shaders.Edit[5].SetBounds(5,30,(vMame.Config.Panel.OGL_Shaders.Groupbox[5].Width- 10),20);
  vMame.Config.Panel.OGL_Shaders.Edit[5].Text:= mame.Emu.Ini.OpenGL_glsl_shader_screen1;
  vMame.Config.Panel.OGL_Shaders.Edit[5].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[10]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[5]);
  vMame.Config.Panel.OGL_Shaders.Button[10].Name:= 'Mame_OpenGLShaders_Button_ScreenShader1_Select';
  vMame.Config.Panel.OGL_Shaders.Button[10].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[5];
  vMame.Config.Panel.OGL_Shaders.Button[10].SetBounds(10,60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[10].Text:= 'Select';
  vMame.Config.Panel.OGL_Shaders.Button[10].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[10].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[11]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[5]);
  vMame.Config.Panel.OGL_Shaders.Button[11].Name:= 'Mame_OpenGLShaders_Button_ScreenShader1_Reset';
  vMame.Config.Panel.OGL_Shaders.Button[11].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[5];
  vMame.Config.Panel.OGL_Shaders.Button[11].SetBounds((vMame.Config.Panel.OGL_Shaders.Groupbox[5].Width- 90),60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[11].Text:= 'Reset';
  vMame.Config.Panel.OGL_Shaders.Button[11].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[11].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Groupbox[6]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Groupbox[6].Name:= 'Mame_OpenGLShaders_Groupbox_ScreenShader2';
  vMame.Config.Panel.OGL_Shaders.Groupbox[6].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Groupbox[6].SetBounds(((vMame.Config.Scene.Right_Panels[5].Width/ 2)+ 5),230,((vMame.Config.Scene.Right_Panels[5].Width/ 2)- 15),90);
  vMame.Config.Panel.OGL_Shaders.Groupbox[6].Text:= 'Screen shader 2';
  vMame.Config.Panel.OGL_Shaders.Groupbox[6].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Edit[6]:= TEdit.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[6]);
  vMame.Config.Panel.OGL_Shaders.Edit[6].Name:= 'Mame_OpenGLShaders_Edit_ScreenShader2';
  vMame.Config.Panel.OGL_Shaders.Edit[6].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[6];
  vMame.Config.Panel.OGL_Shaders.Edit[6].SetBounds(5,30,(vMame.Config.Panel.OGL_Shaders.Groupbox[6].Width- 10),20);
  vMame.Config.Panel.OGL_Shaders.Edit[6].Text:= mame.Emu.Ini.OpenGL_glsl_shader_screen2;
  vMame.Config.Panel.OGL_Shaders.Edit[6].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[12]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[6]);
  vMame.Config.Panel.OGL_Shaders.Button[12].Name:= 'Mame_OpenGLShaders_Button_ScreenShader2_Select';
  vMame.Config.Panel.OGL_Shaders.Button[12].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[6];
  vMame.Config.Panel.OGL_Shaders.Button[12].SetBounds(10,60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[12].Text:= 'Select';
  vMame.Config.Panel.OGL_Shaders.Button[12].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[12].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[13]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[6]);
  vMame.Config.Panel.OGL_Shaders.Button[13].Name:= 'Mame_OpenGLShaders_Button_ScreenShader2_Reset';
  vMame.Config.Panel.OGL_Shaders.Button[13].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[6];
  vMame.Config.Panel.OGL_Shaders.Button[13].SetBounds((vMame.Config.Panel.OGL_Shaders.Groupbox[6].Width- 90),60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[13].Text:= 'Reset';
  vMame.Config.Panel.OGL_Shaders.Button[13].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[13].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Groupbox[7]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[5]);
  vMame.Config.Panel.OGL_Shaders.Groupbox[7].Name:= 'Mame_OpenGLShaders_Groupbox_ScreenShader3';
  vMame.Config.Panel.OGL_Shaders.Groupbox[7].Parent:= vMame.Config.Scene.Right_Panels[5];
  vMame.Config.Panel.OGL_Shaders.Groupbox[7].SetBounds(((vMame.Config.Scene.Right_Panels[5].Width/ 2)+ 5),325,((vMame.Config.Scene.Right_Panels[5].Width/ 2)- 15),90);
  vMame.Config.Panel.OGL_Shaders.Groupbox[7].Text:= 'Screen shader 3';
  vMame.Config.Panel.OGL_Shaders.Groupbox[7].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Edit[7]:= TEdit.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[7]);
  vMame.Config.Panel.OGL_Shaders.Edit[7].Name:= 'Mame_OpenGLShaders_Edit_ScreenShader3';
  vMame.Config.Panel.OGL_Shaders.Edit[7].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[7];
  vMame.Config.Panel.OGL_Shaders.Edit[7].SetBounds(5,30,(vMame.Config.Panel.OGL_Shaders.Groupbox[7].Width- 10),20);
  vMame.Config.Panel.OGL_Shaders.Edit[7].Text:= mame.Emu.Ini.OpenGL_glsl_shader_screen3;
  vMame.Config.Panel.OGL_Shaders.Edit[7].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[14]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[7]);
  vMame.Config.Panel.OGL_Shaders.Button[14].Name:= 'Mame_OpenGLShaders_Button_ScreenShader3_Select';
  vMame.Config.Panel.OGL_Shaders.Button[14].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[7];
  vMame.Config.Panel.OGL_Shaders.Button[14].SetBounds(10,60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[14].Text:= 'Select';
  vMame.Config.Panel.OGL_Shaders.Button[14].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[14].Visible:= True;

  vMame.Config.Panel.OGL_Shaders.Button[15]:= TButton.Create(vMame.Config.Panel.OGL_Shaders.Groupbox[7]);
  vMame.Config.Panel.OGL_Shaders.Button[15].Name:= 'Mame_OpenGLShaders_Button_ScreenShader3_Reset';
  vMame.Config.Panel.OGL_Shaders.Button[15].Parent:= vMame.Config.Panel.OGL_Shaders.Groupbox[7];
  vMame.Config.Panel.OGL_Shaders.Button[15].SetBounds((vMame.Config.Panel.OGL_Shaders.Groupbox[7].Width- 90),60,80,20);
  vMame.Config.Panel.OGL_Shaders.Button[15].Text:= 'Reset';
  vMame.Config.Panel.OGL_Shaders.Button[15].OnClick:= mame.Config.Input.Mouse.Button.onMouseClick;
  vMame.Config.Panel.OGL_Shaders.Button[15].Visible:= True;
end;

////////////////////////////////////////////////////////////////////////////////
procedure uEmu_Arcade_Mame_Config_OpenGL_Shaders_ButtonClick(vName: String);
begin
  if vName= 'Mame_OpenGLShaders_Button_MameShader0_Select' then
    begin
      mame.Config.Panel.OGL_Shaders.OpenDialog_Result:= 'Mame_Shader_0';
      vMame.Config.Panel.OGL_Shaders.OpenDialog.Execute;
    end
  else if vName= 'Mame_OpenGLShaders_Button_MameShader0_Reset' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[0].Text:= 'none';
      mame.Emu.Ini.OpenGL_glsl_shader_mame0:= 'none';
    end
  else if vName= 'Mame_OpenGLShaders_Button_MameShader1_Select' then
    begin
      mame.Config.Panel.OGL_Shaders.OpenDialog_Result:= 'Mame_Shader_1';
      vMame.Config.Panel.OGL_Shaders.OpenDialog.Execute;
    end
  else if vName= 'Mame_OpenGLShaders_Button_MameShader1_Reset' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[1].Text:= 'none';
      mame.Emu.Ini.OpenGL_glsl_shader_mame1:= 'none';
    end
  else if vName= 'Mame_OpenGLShaders_Button_MameShader2_Select' then
    begin
      mame.Config.Panel.OGL_Shaders.OpenDialog_Result:= 'Mame_Shader_2';
      vMame.Config.Panel.OGL_Shaders.OpenDialog.Execute;
    end
  else if vName= 'Mame_OpenGLShaders_Button_MameShader2_Reset' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[2].Text:= 'none';
      mame.Emu.Ini.OpenGL_glsl_shader_mame2:= 'none';
    end
  else if vName= 'Mame_OpenGLShaders_Button_MameShader3_Select' then
    begin
      mame.Config.Panel.OGL_Shaders.OpenDialog_Result:= 'Mame_Shader_3';
      vMame.Config.Panel.OGL_Shaders.OpenDialog.Execute;
    end
  else if vName= 'Mame_OpenGLShaders_Button_MameShader3_Reset' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[3].Text:= 'none';
      mame.Emu.Ini.OpenGL_glsl_shader_mame3:= 'none';
    end
  else if vName= 'Mame_OpenGLShaders_Button_ScreenShader0_Select' then
    begin
      mame.Config.Panel.OGL_Shaders.OpenDialog_Result:= 'Screen_Shader_0';
      vMame.Config.Panel.OGL_Shaders.OpenDialog.Execute;
    end
  else if vName= 'Mame_OpenGLShaders_Button_ScreenShader0_Reset' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[4].Text:= 'none';
      mame.Emu.Ini.OpenGL_glsl_shader_screen0:= 'none';
    end
  else if vName= 'Mame_OpenGLShaders_Button_ScreenShader1_Select' then
    begin
      mame.Config.Panel.OGL_Shaders.OpenDialog_Result:= 'Screen_Shader_1';
      vMame.Config.Panel.OGL_Shaders.OpenDialog.Execute;
    end
  else if vName= 'Mame_OpenGLShaders_Button_ScreenShader1_Reset' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[5].Text:= 'none';
      mame.Emu.Ini.OpenGL_glsl_shader_screen1:= 'none';
    end
  else if vName= 'Mame_OpenGLShaders_Button_ScreenShader2_Select' then
    begin
      mame.Config.Panel.OGL_Shaders.OpenDialog_Result:= 'Screen_Shader_2';
      vMame.Config.Panel.OGL_Shaders.OpenDialog.Execute;
    end
  else if vName= 'Mame_OpenGLShaders_Button_ScreenShader2_Reset' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[6].Text:= 'none';
      mame.Emu.Ini.OpenGL_glsl_shader_screen2:= 'none';
    end
  else if vName= 'Mame_OpenGLShaders_Button_ScreenShader3_Select' then
    begin
      mame.Config.Panel.OGL_Shaders.OpenDialog_Result:= 'Screen_Shader_3';
      vMame.Config.Panel.OGL_Shaders.OpenDialog.Execute;
    end
  else if vName= 'Mame_OpenGLShaders_Button_ScreenShader3_Reset' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[7].Text:= 'none';
      mame.Emu.Ini.OpenGL_glsl_shader_screen3:= 'none';
    end
end;

procedure uEmu_Arcade_Mame_Config_OpenGL_Shaders_OpenDialog;
begin
  if mame.Config.Panel.OGL_Shaders.OpenDialog_Result= 'Mame_Shader_0' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[0].Text:= ExtractFileName(vMame.Config.Panel.OGL_Shaders.OpenDialog.FileName);
      mame.Emu.Ini.OpenGL_glsl_shader_mame0:= vMame.Config.Panel.OGL_Shaders.Edit[0].Text;
    end
  else if mame.Config.Panel.OGL_Shaders.OpenDialog_Result= 'Mame_Shader_1' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[1].Text:= ExtractFileName(vMame.Config.Panel.OGL_Shaders.OpenDialog.FileName);
      mame.Emu.Ini.OpenGL_glsl_shader_mame1:= vMame.Config.Panel.OGL_Shaders.Edit[1].Text;
    end
  else if mame.Config.Panel.OGL_Shaders.OpenDialog_Result= 'Mame_Shader_2' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[2].Text:= ExtractFileName(vMame.Config.Panel.OGL_Shaders.OpenDialog.FileName);
      mame.Emu.Ini.OpenGL_glsl_shader_mame2:= vMame.Config.Panel.OGL_Shaders.Edit[2].Text;
    end
  else if mame.Config.Panel.OGL_Shaders.OpenDialog_Result= 'Mame_Shader_3' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[3].Text:= ExtractFileName(vMame.Config.Panel.OGL_Shaders.OpenDialog.FileName);
      mame.Emu.Ini.OpenGL_glsl_shader_mame3:= vMame.Config.Panel.OGL_Shaders.Edit[3].Text;
    end
  else if mame.Config.Panel.OGL_Shaders.OpenDialog_Result= 'Screen_Shader_0' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[4].Text:= ExtractFileName(vMame.Config.Panel.OGL_Shaders.OpenDialog.FileName);
      mame.Emu.Ini.OpenGL_glsl_shader_screen0:= vMame.Config.Panel.OGL_Shaders.Edit[4].Text;
    end
  else if mame.Config.Panel.OGL_Shaders.OpenDialog_Result= 'Screen_Shader_1' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[5].Text:= ExtractFileName(vMame.Config.Panel.OGL_Shaders.OpenDialog.FileName);
      mame.Emu.Ini.OpenGL_glsl_shader_screen1:= vMame.Config.Panel.OGL_Shaders.Edit[5].Text;
    end
  else if mame.Config.Panel.OGL_Shaders.OpenDialog_Result= 'Screen_Shader_2' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[6].Text:= ExtractFileName(vMame.Config.Panel.OGL_Shaders.OpenDialog.FileName);
      mame.Emu.Ini.OpenGL_glsl_shader_screen2:= vMame.Config.Panel.OGL_Shaders.Edit[6].Text;
    end
  else if mame.Config.Panel.OGL_Shaders.OpenDialog_Result= 'Screen_Shader_3' then
    begin
      vMame.Config.Panel.OGL_Shaders.Edit[7].Text:= ExtractFileName(vMame.Config.Panel.OGL_Shaders.OpenDialog.FileName);
      mame.Emu.Ini.OpenGL_glsl_shader_screen3:= vMame.Config.Panel.OGL_Shaders.Edit[7].Text;
    end
end;

end.
