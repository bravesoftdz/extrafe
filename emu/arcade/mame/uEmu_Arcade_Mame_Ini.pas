unit uEmu_Arcade_Mame_Ini;

interface
uses
  System.Classes,
  System.Inifiles,
  System.SysUtils,
  OXmlPDOM;

  procedure uEmu_Arcade_Mame_Ini_Load;
  procedure uEmu_Arcade_Mame_Ini_Save;
  procedure uEmu_Arcade_Mame_Ini_Free;

  procedure uEmu_Arcade_Mame_Ini_GetMediaPaths;
  procedure uEmu_Arcade_Mame_Ini_SaveMediaPaths;

implementation
uses
  uLoad_AllTypes,
  uEmu_SetAll,
  uEmu_Arcade_Mame_AllTypes;

procedure uEmu_Arcade_Mame_Ini_Load;
var
  vText: TextFile;
  vTLine, vT1, vT2: String;
  vPos: Integer;

  procedure uEmu_Arcade_Mame_SetValue_To_Ini(vParam, vValue: WideString);
  var
    v1Pos: Integer;
    v1Line, v1Result: String;
  begin
    //Core Configuration options
    if vParam= 'readconfig' then
      mame.Emu.Ini.CORE_CONFIGURATION_readconfig:= StrToBool(vValue)
    else if vParam= 'writeconfig' then
      mame.Emu.Ini.CORE_CONFIGURATION_writeconfig:= StrToBool(vValue)
    //Core Search path options
    else if vParam= 'homepath' then
      mame.Emu.Ini.CORE_SEARCH_homepath:= vValue
    else if vParam= 'rompath' then
      begin
        v1Pos:= Pos(';', vValue);
        if v1Pos<> 0 then
          begin
            v1Line:= vValue;
            repeat
              v1Pos:= Pos(';', v1Line);
              if v1Pos= 0  then
                mame.Emu.Ini.CORE_SEARCH_rompath.Add(v1Line)
              else
                begin
                  v1Result:= Trim(Copy(v1Line, 0, v1Pos- 1));
                  mame.Emu.Ini.CORE_SEARCH_rompath.Add(v1Result);
                  v1Line:= Trim(Copy(v1Line, v1Pos+ 1, length(v1Line)- (v1Pos)));
                end;
            until v1Pos= 0;
          end
        else
          mame.Emu.Ini.CORE_SEARCH_rompath.Add(vValue);
      end
    else if vParam= 'hashpath' then
      mame.Emu.Ini.CORE_SEARCH_hashpath:= vValue
    else if vParam= 'samplepath' then
      mame.Emu.Ini.CORE_SEARCH_samplepath:= vValue
    else if vParam= 'artpath'  then
      mame.Emu.Ini.CORE_SEARCH_artpath:= vValue
    else if vParam= 'ctrlrpath' then
      mame.Emu.Ini.CORE_SEARCH_ctrlrpath:= vValue
    else if vParam= 'inipath' then
      begin
        v1Pos:= Pos(';', vValue);
        if v1Pos<> 0 then
          begin
            v1Line:= vValue;
            repeat
              v1Pos:= Pos(';', v1Line);
              if v1Pos= 0  then
                mame.Emu.Ini.CORE_SEARCH_inipath.Add(v1Line)
              else
                begin
                  v1Result:= Trim(Copy(v1Line, 0, v1Pos- 1));
                  mame.Emu.Ini.CORE_SEARCH_inipath.Add(v1Result);
                  v1Line:= Trim(Copy(v1Line, v1Pos+ 1, length(v1Line)- (v1Pos)));
                end;
            until v1Pos= 0;
          end
        else
          mame.Emu.Ini.CORE_SEARCH_inipath.Add(vValue);
      end
    else if vParam= 'fontpath' then
      mame.Emu.Ini.CORE_SEARCH_fontpath:= vValue
    else if vParam= 'cheatpath' then
      mame.Emu.Ini.CORE_SEARCH_cheatpath:= vValue
    else if vParam= 'crosshairpath' then
      mame.Emu.Ini.CORE_SEARCH_crosshairpath:= vValue
    else if vParam= 'pluginspath' then
      mame.Emu.Ini.CORE_SEARCH_pluginspath:= vValue
    else if vParam= 'languagepath' then
      mame.Emu.Ini.CORE_SEARCH_languagepath:= vValue
    else if vParam= 'swpath' then
      mame.Emu.Ini.CORE_SEARCH_swpath:= vValue
    //Core Output directory optiions
    else if vParam= 'cfg_directory' then
      mame.Emu.Ini.CORE_OUTPUT_cfg_directory:= vValue
    else if vParam= 'nvram_directory' then
      mame.Emu.Ini.CORE_OUTPUT_nvram_directory:= vValue
    else if vParam= 'input_directory' then
      mame.Emu.Ini.CORE_OUTPUT_input_directory:= vValue
    else if vParam= 'state_directory' then
      mame.Emu.Ini.CORE_OUTPUT_state_directory:= vValue
    else if vParam= 'snapshot_directory' then
      mame.Emu.Ini.CORE_OUTPUT_snapshot_directory:= vValue
    else if vParam= 'diff_directory' then
      mame.Emu.Ini.CORE_OUTPUT_diff_directory:= vValue
    else if vParam= 'comment_directory' then
      mame.Emu.Ini.CORE_OUTPUT_comment_directory:= vValue
    //Core State/Playback options
    else if vParam= 'state' then
      mame.Emu.Ini.CORE_STATE_state:= vValue
    else if vParam= 'autosave' then
      mame.Emu.Ini.CORE_STATE_autosave:= StrToBool(vValue)
    else if vParam= 'rewind' then
      mame.Emu.Ini.CORE_STATE_rewind:= StrToBool(vValue)
    else if vParam= 'rewind_capacity' then
      mame.Emu.Ini.CORE_STATE_rewind_capacity:= StrToInt(vValue)
    else if vParam= 'playback' then
      mame.Emu.Ini.CORE_STATE_playback:= vValue
    else if vParam= 'record' then
      mame.Emu.Ini.CORE_STATE_record:= vValue
    else if vParam= 'record_timecode' then
      mame.Emu.Ini.CORE_STATE_record_timecode:= StrToBool(vValue)
    else if vParam= 'exit_after_playback' then
      mame.Emu.Ini.CORE_STATE_exit_after_playback:= StrToBool(vValue)
    else if vParam= 'mngwrite' then
      mame.Emu.Ini.CORE_STATE_mngwrite:= vValue
    else if vParam= 'aviwrite' then
      mame.Emu.Ini.CORE_STATE_aviwrite:= vValue
    else if vParam= 'wavwrite' then
      mame.Emu.Ini.CORE_STATE_wavwrite:= vValue
    else if vParam= 'snapname' then
      mame.Emu.Ini.CORE_STATE_snapname:= vValue
    else if vParam= 'snapsize' then
      mame.Emu.Ini.CORE_STATE_snapsize:= vValue
    else if vParam= 'snapview' then
      mame.Emu.Ini.CORE_STATE_snapview:= vValue
    else if vParam= 'snapbilinear' then
      mame.Emu.Ini.CORE_STATE_snapbilinear:= StrToBool(vValue)
    else if vParam= 'statename' then
      mame.Emu.Ini.CORE_STATE_statename:= vValue
    else if vParam= 'burnin' then
      mame.Emu.Ini.CORE_STATE_burnin:= StrToBool(vValue)
    //Core Prerformance options
    else if vParam= 'autoframeskip' then
      mame.Emu.Ini.CORE_PERFORMANCE_autoframeskip:= StrToBool(vValue)
    else if vParam= 'frameskip' then
      mame.Emu.Ini.CORE_PERFORMANCE_frameskip:= StrToInt(vValue)
    else if vParam= 'seconds_to_run' then
      mame.Emu.Ini.CORE_PERFORMANCE_seconds_to_run:= StrToInt(vValue)
    else if vParam= 'throttle' then
      mame.Emu.Ini.CORE_PERFORMANCE_throttle:= StrToBool(vValue)
    else if vParam= 'sleep' then
      mame.Emu.Ini.CORE_PERFORMANCE_sleep:= StrToBool(vValue)
    else if vParam= 'speed' then
      mame.Emu.Ini.CORE_PERFORMANCE_speed:= vValue
    else if vParam= 'refreshspeed' then
      mame.Emu.Ini.CORE_PERFORMANCE_refreshspeed:= StrToBool(vValue)
    else if (mame.Emu.Name= 'arcade64.exe') or (mame.Emu.Name= 'Arcade32.exe') then
      begin
        if vParam= 'syncrefresh'  then
          mame.Emu.Ini.CORE_PERFORMANCE_syncrefresh:= StrToBool(vValue)
      end
    //Core Render options
    else if vParam= 'keepaspect' then
      mame.Emu.Ini.CORE_RENDER_keepaspect:= StrToBool(vValue)
    else if vParam= 'unevenstretch' then
      mame.Emu.Ini.CORE_RENDER_unevenstretch:= StrToBool(vValue)
    else if vParam= 'unevenstretchx' then
      mame.Emu.Ini.CORE_RENDER_unevenstretchx:= StrToBool(vValue)
    else if vParam= 'unevenstretchy' then
      mame.Emu.Ini.CORE_RENDER_unevenstretchy:= StrToBool(vValue)
    else if vParam= 'autostretchxy' then
      mame.Emu.Ini.CORE_RENDER_autostretchxy:= StrToBool(vValue)
    else if vParam= 'intoverscan' then
      mame.Emu.Ini.CORE_RENDER_intoverscan:= StrToBool(vValue)
    else if vParam= 'intscalex' then
      mame.Emu.Ini.CORE_RENDER_intscalex:= StrToFloat(vValue)
    else if vParam= 'intscaley' then
      mame.Emu.Ini.CORE_RENDER_intscaley:= StrToFloat(vValue)
    //Core Rotation options
    else if vParam= 'rotate' then
      mame.Emu.Ini.CORE_ROTATION_rotate:= StrToBool(vValue)
    else if vParam= 'ror' then
      mame.Emu.Ini.CORE_ROTATION_ror:= StrToBool(vValue)
    else if vParam= 'rol' then
      mame.Emu.Ini.CORE_ROTATION_rol:= StrToBool(vValue)
    else if vParam= 'autoror' then
      mame.Emu.Ini.CORE_ROTATION_autoror:= StrToBool(vValue)
    else if vParam= 'autorol' then
      mame.Emu.Ini.CORE_ROTATION_autorol:= StrToBool(vValue)
    else if vParam= 'flipx' then
      mame.Emu.Ini.CORE_ROTATION_flipx:= StrToBool(vValue)
    else if vParam= 'flipy' then
      mame.Emu.Ini.CORE_ROTATION_flipy:= StrToBool(vValue)
    //Core Artwork options
    else if vParam= 'artwork_crop' then
      mame.Emu.Ini.CORE_ARTWORK_artwork_crop:= StrToBool(vValue)
    else if vParam= 'use_backdrops' then
      mame.Emu.Ini.CORE_ARTWORK_use_backdrops:= StrToBool(vValue)
    else if vParam= 'use_overlays' then
      mame.Emu.Ini.CORE_ARTWORK_use_overlays:= StrToBool(vValue)
    else if vParam= 'use_bezels' then
      mame.Emu.Ini.CORE_ARTWORK_use_bezels:= StrToBool(vValue)
    else if vParam= 'use_cpanels' then
      mame.Emu.Ini.CORE_ARTWORK_use_cpanels:= StrToBool(vValue)
    else if vParam= 'use_marquees' then
      mame.Emu.Ini.CORE_ARTWORK_use_marquees:= StrToBool(vValue)
    else if vParam= 'fallback_artwork' then
      mame.Emu.Ini.CORE_ARTWORK_fallback_artwork:= vValue
    else if vParam= 'override_artwork' then
      mame.Emu.Ini.CORE_ARTWORK_override_artwork:= vValue
    //Core Screen options
    else if vParam= 'brightness' then
      mame.Emu.Ini.CORE_SCREEN_brightness:= vValue
    else if vParam= 'contrast' then
      mame.Emu.Ini.CORE_SCREEN_contrast:= vValue
    else if vParam= 'gamma' then
      mame.Emu.Ini.CORE_SCREEN_gamma:= vValue
    else if vParam= 'pause_brightness' then
      mame.Emu.Ini.CORE_SCREEN_pause_brightness:= vValue
    else if vParam= 'effect' then
      mame.Emu.Ini.CORE_SCREEN_effect:= vValue
    //Arcade 64 specific line
    else if vParam= 'widestretch' then
      mame.Emu.Ini.CORE_SCREEN_widestretch:= StrToBool(vValue)
    //
    //Core Vector options
    else if vParam= 'beam_width_min' then
      mame.Emu.Ini.CORE_VECTOR_beam_width_min:= vValue
    else if vParam= 'beam_width_max' then
      mame.Emu.Ini.CORE_VECTOR_beam_width_max:= vValue
    else if vParam= 'beam_intensity_weight' then
      mame.Emu.Ini.CORE_VECTOR_beam_intensity_weight:= vValue
    else if vParam= 'flicker' then
      mame.Emu.Ini.CORE_VECTOR_flicker:= vValue
    //Core Sound options
    else if vParam= 'samplerate' then
      mame.Emu.Ini.CORE_SOUND_samplerate:= vValue
    else if vParam= 'samples' then
      mame.Emu.Ini.CORE_SOUND_samples:= StrToBool(vValue)
    else if vParam= 'volume' then
      mame.Emu.Ini.CORE_SOUND_volume:= vValue
    //Core Input options
    else if vParam= 'coin_lockout' then
      mame.Emu.Ini.CORE_INPUT_coin_lockout:= StrToBool(vValue)
    else if vParam= 'ctrlr' then
      mame.Emu.Ini.CORE_INPUT_ctrlr:= vValue
    else if vParam= 'mouse' then
      mame.Emu.Ini.CORE_INPUT_mouse:= StrToBool(vValue)
    else if vParam= 'joystick' then
      mame.Emu.Ini.CORE_INPUT_joystick:= StrToBool(vValue)
    else if vParam= 'lightgun' then
      mame.Emu.Ini.CORE_INPUT_lightgun:= StrToBool(vValue)
    else if vParam= 'multikeyboard' then
      mame.Emu.Ini.CORE_INPUT_multikeyboard:= StrToBool(vValue)
    else if vParam= 'multimouse' then
      mame.Emu.Ini.CORE_INPUT_multimouse:= StrToBool(vValue)
    else if vParam= 'steadykey' then
      mame.Emu.Ini.CORE_INPUT_steadykey:= StrToBool(vValue)
    else if vParam= 'ui_active' then
      mame.Emu.Ini.CORE_INPUT_ui_active:= StrToBool(vValue)
    else if vParam= 'offscreen_reload' then
      mame.Emu.Ini.CORE_INPUT_offscreen_reload:= StrToBool(vValue)
    else if vParam= 'joystick_map' then
      mame.Emu.Ini.CORE_INPUT_joystick_map:= vValue
    else if vParam= 'joystick_deadzone' then
      mame.Emu.Ini.CORE_INPUT_joystick_deadzone:= vValue
    else if vParam= 'joystick_saturation' then
      mame.Emu.Ini.CORE_INPUT_joystick_saturation:= vValue
    else if vParam= 'natural' then
      mame.Emu.Ini.CORE_INPUT_natural:= StrToBool(vValue)
    else if vParam= 'joystick_contradictory' then
      mame.Emu.Ini.CORE_INPUT_joystick_contradictory:= StrToBool(vValue)
    else if vParam= 'coin_impulse' then
      mame.Emu.Ini.CORE_INPUT_coin_impulse:= StrToBool(vValue)
    //Core Input Automatic Enable options
    else if vParam= 'paddle_device' then
      mame.Emu.Ini.CORE_INPUT_AUTOMATIC_paddle_device:= vValue
    else if vParam= 'adstick_device' then
      mame.Emu.Ini.CORE_INPUT_AUTOMATIC_adstick_device:= vValue
    else if vParam= 'pedal_device' then
      mame.Emu.Ini.CORE_INPUT_AUTOMATIC_pedal_device:= vValue
    else if vParam= 'dial_device' then
      mame.Emu.Ini.CORE_INPUT_AUTOMATIC_dial_device:= vValue
    else if vParam= 'trackball_device' then
      mame.Emu.Ini.CORE_INPUT_AUTOMATIC_trackball_device:= vValue
    else if vParam= 'lightgun_device' then
      mame.Emu.Ini.CORE_INPUT_AUTOMATIC_lightgun_device:= vValue
    else if vParam= 'positional_device' then
      mame.Emu.Ini.CORE_INPUT_AUTOMATIC_positional_device:= vValue
    else if vParam= 'mouse_device' then
      mame.Emu.Ini.CORE_INPUT_AUTOMATIC_mouse_device:= vValue
    //Core Debugging options
    else if vParam= 'verbose' then
      mame.Emu.Ini.CORE_DEBUGGING_verbose:= StrToBool(vValue)
    else if vParam= 'log' then
      mame.Emu.Ini.CORE_DEBUGGING_log:= StrToBool(vValue)
    else if vParam= 'oslog' then
      mame.Emu.Ini.CORE_DEBUGGING_oslog:= StrToBool(vValue)
    else if vParam= 'debug' then
      mame.Emu.Ini.CORE_DEBUGGING_debug:= StrToBool(vValue)
    else if vParam= 'update_in_pause' then
      mame.Emu.Ini.CORE_DEBUGGING_update_in_pause:= StrToBool(vValue)
    else if vParam= 'debugscript' then
      mame.Emu.Ini.CORE_DEBUGGING_debugscript:= vValue
    //Core Comm options
    else if vParam= 'comm_localhost' then
      mame.Emu.Ini.CORE_COMM_comm_localhost:= vValue
    else if vParam= 'comm_localport' then
      mame.Emu.Ini.CORE_COMM_comm_localport:= vValue
    else if vParam= 'comm_remotehost' then
      mame.Emu.Ini.CORE_COMM_comm_remotehost:= vValue
    else if vParam= 'comm_remoteport' then
      mame.Emu.Ini.CORE_COMM_comm_remoteport:= vValue
    //Core Misc options
    else if vParam= 'drc' then
      mame.Emu.Ini.CORE_MISC_drc:= StrToBool(vValue)
    else if vParam= 'drc_use_c' then
      mame.Emu.Ini.CORE_MISC_drc_use_c:= StrToBool(vValue)
    else if vParam= 'drc_log_uml' then
      mame.Emu.Ini.CORE_MISC_drc_log_uml:= StrToBool(vValue)
    else if vParam= 'drc_log_native' then
      mame.Emu.Ini.CORE_MISC_drc_log_native:= StrToBool(vValue)
    else if vParam= 'bios' then
      mame.Emu.Ini.CORE_MISC_bios:= vValue
    else if vParam= 'cheat' then
      mame.Emu.Ini.CORE_MISC_cheat:= StrToBool(vValue)
    else if vParam= 'skip_gameinfo' then
      mame.Emu.Ini.CORE_MISC_skip_gameinfo:= StrToBool(vValue)
    else if vParam= 'uifont' then
      mame.Emu.Ini.CORE_MISC_uifont:= vValue
    else if vParam= 'ui' then
      mame.Emu.Ini.CORE_MISC_ui:= vValue
    else if vParam= 'ramsize' then
      mame.Emu.Ini.CORE_MISC_ramsize:= vValue
    else if vParam= 'confirm_quit' then
      mame.Emu.Ini.CORE_MISC_confirm_quit:= StrToBool(vValue)
    else if vparam= 'ui_mouse' then
      mame.Emu.Ini.CORE_MISC_ui_mouse:= StrToBool(vValue)
    else if vParam= 'language' then
      mame.Emu.Ini.CORE_MISC_language:= vValue
    else if vParam= 'nvram_save' then
      mame.Emu.Ini.CORE_MISC_nvram_save:= StrToBool(vValue)
    //Scripting options
    else if vParam= 'autoboot_command' then
      mame.Emu.Ini.SCRIPTING_autoboot_command:= vValue
    else if vParam= 'autoboot_delay' then
      mame.Emu.Ini.SCRIPTING_autoboot_delay:= vValue
    else if vParam= 'autoboot_script' then
      mame.Emu.Ini.SCRIPTING_autoboot_script:= vValue
    else if vParam= 'console' then
      mame.Emu.Ini.SCRIPTING_console:= StrToBool(vValue)
    else if vParam= 'plugins' then
      mame.Emu.Ini.SCRIPTING_plugins:= StrToBool(vValue)
    else if vParam= 'plugin' then
      mame.Emu.Ini.SCRIPTING_plugin:= vValue
    else if vParam= 'noplugin' then
      mame.Emu.Ini.SCRIPTING_noplugin:= vValue
    //HTTP Server options
    else if vParam= 'http' then
      mame.Emu.Ini.HTTP_http:= vValue
    else if vParam= 'http_port' then
      mame.Emu.Ini.HTTP_port:= vValue
    else if vParam= 'http_root' then
      mame.Emu.Ini.HTTP_root:= vValue
    //Osd Keyboard mapping options
    else if vParam= 'uimodekey' then
      mame.Emu.Ini.OSD_KEYBOARD_uimodekey:= vValue
    //Osd Font options
    else if vParam= 'uifontprovider' then
      mame.Emu.Ini.OSD_FONT_uifontprovider:= vValue
    //Osd Output options
    else if vParam= 'output' then
      mame.Emu.Ini.OSD_OUTPUT_output:= vValue
    //Osd Input options
    else if vParam= 'keyboardprovider' then
      mame.Emu.Ini.OSD_INPUT_keyboardprovider:= vValue
    else if vParam= 'mouseprovider' then
      mame.Emu.Ini.OSD_INPUT_mouseprovider:= vValue
    else if vParam= 'lightgunprovider' then
      mame.Emu.Ini.OSD_INPUT_lightgunprovider:= vValue
    else if vParam= 'joystickprovider' then
      mame.Emu.Ini.OSD_INPUT_joystickprovider:= vValue
    //Osd Debugging options
    else if vParam= 'debugger' then
      mame.Emu.Ini.OSD_DEBUGGING_debugger:= vValue
    else if vParam= 'debugger_font' then
      mame.Emu.Ini.OSD_DEBUGGING_debugger_font:= vValue
    else if vParam= 'debugger_font_size' then
      mame.Emu.Ini.OSD_DEBUGGING_debugger_font_size:= StrToInt(vValue)
    else if vParam= 'watchdog' then
      mame.Emu.Ini.OSD_DEBUGGING_watchdog:= StrToBool(vValue)
    //Osd Performance options
    else if vParam= 'numprocessors' then
      mame.Emu.Ini.OSD_PERFORMANCE_numprocessors:= vValue
    else if vParam= 'bench' then
      mame.Emu.Ini.OSD_PERFORMANCE_bench:= StrToBool(vValue)
    //Osd Video options
    else if vParam= 'video' then
      mame.Emu.Ini.OSD_VIDEO_video:= vValue
    else if vParam= 'numscreens' then
      mame.Emu.Ini.OSD_VIDEO_numscreens:= StrToInt(vValue)
    else if vParam= 'window' then
      mame.Emu.Ini.OSD_VIDEO_window:= StrToBool(vValue)
    else if vParam= 'maximize' then
      mame.Emu.Ini.OSD_VIDEO_maximize:= StrToBool(vValue)
    else if vParam= 'waitvsync' then
      mame.Emu.Ini.OSD_VIDEO_waitvsync:= StrToBool(vValue)
    else if vParam= 'syncrefresh' then
      mame.Emu.Ini.OSD_VIDEO_syncrefresh:= StrToBool(vValue)
    else if vParam= 'monitorprovider' then
      mame.Emu.Ini.OSD_VIDEO_monitorprovider:= vValue
    //Osd Per_Window Video options
    else if vParam= 'screen' then
      mame.Emu.Ini.OSD_PER_WINDOW_screen:= vValue
    else if vParam= 'aspect' then
      mame.Emu.Ini.OSD_PER_WINDOW_aspect:= vValue
    else if vParam= 'resolution' then
      mame.Emu.Ini.OSD_PER_WINDOW_resolution:= vValue
    else if vParam= 'view' then
      mame.Emu.Ini.OSD_PER_WINDOW_view:= vValue
    else if vParam= 'screen0' then
      mame.Emu.Ini.OSD_PER_WINDOW_screen0:= vValue
    else if vParam= 'aspect0' then
      mame.Emu.Ini.OSD_PER_WINDOW_aspect0:= vValue
    else if vParam= 'resolution0' then
      mame.Emu.Ini.OSD_PER_WINDOW_resolution0:= vValue
    else if vParam= 'view0' then
      mame.Emu.Ini.OSD_PER_WINDOW_view0:= vValue
    else if vParam= 'screen1' then
      mame.Emu.Ini.OSD_PER_WINDOW_screen1:= vValue
    else if vParam= 'aspect1' then
      mame.Emu.Ini.OSD_PER_WINDOW_aspect1:= vValue
    else if vParam= 'resolution1' then
      mame.Emu.Ini.OSD_PER_WINDOW_resolution1:= vValue
    else if vParam= 'view1' then
      mame.Emu.Ini.OSD_PER_WINDOW_view1:= vValue
    else if vParam= 'screen2' then
      mame.Emu.Ini.OSD_PER_WINDOW_screen2:= vValue
    else if vParam= 'aspect2' then
      mame.Emu.Ini.OSD_PER_WINDOW_aspect2:= vValue
    else if vParam= 'resolution2' then
      mame.Emu.Ini.OSD_PER_WINDOW_resolution2:= vValue
    else if vParam= 'view2' then
      mame.Emu.Ini.OSD_PER_WINDOW_view2:= vValue
    else if vParam= 'screen3' then
      mame.Emu.Ini.OSD_PER_WINDOW_screen3:= vValue
    else if vParam= 'aspect3' then
      mame.Emu.Ini.OSD_PER_WINDOW_aspect3:= vValue
    else if vParam= 'resolution3' then
      mame.Emu.Ini.OSD_PER_WINDOW_resolution3:= vValue
    else if vParam= 'view3' then
      mame.Emu.Ini.OSD_PER_WINDOW_view3:= vValue
    //Osd Fullscreen options
    else if vParam= 'switchres' then
      mame.Emu.Ini.OSD_FULLSCREEN_switchres:= StrToBool(vValue)
    //Osd Accelerated Video options
    else if vParam= 'filter' then
      mame.Emu.Ini.OSD_ACCELERATED_filter:= StrToBool(vValue)
    else if vParam= 'prescale' then
      mame.Emu.Ini.OSD_ACCELERATED_prescale:= StrToInt(vValue)
    //OpenGL specific options
    else if vParam= 'gl_forcepow2texture' then
      mame.Emu.Ini.OpenGL_gl_forcepow2texture:= StrToBool(vValue)
    else if vParam= 'gl_notexturerect' then
      mame.Emu.Ini.OpenGL_gl_notexturerect:= StrToBool(vValue)
    else if vParam= 'gl_vbo' then
      mame.Emu.Ini.OpenGL_gl_vbo:= StrToBool(vValue)
    else if vParam= 'gl_pbo' then
      mame.Emu.Ini.OpenGL_gl_pbo:= StrToBool(vValue)
    else if vParam= 'gl_glsl' then
      mame.Emu.Ini.OpenGL_gl_glsl:= StrToBool(vValue)
    else if (mame.Emu.Name= 'arcade64') or (mame.Emu.Name= 'arcade32') then
      begin
        if vParam= 'gl_glsl_sync' then
          mame.Emu.Ini.OpenGL_gl_glsl_sync:= StrToBool(vValue)
      end

    else if vParam= 'gl_glsl_filter' then
      mame.Emu.Ini.OpenGL_gl_glsl_filter:= StrToInt(vValue)
    else if vParam= 'glsl_shader_mame0' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame0:= vValue
    else if vParam= 'glsl_shader_mame1' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame1:= vValue
    else if vParam= 'glsl_shader_mame2' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame2:= vValue
    else if vParam= 'glsl_shader_mame3' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame3:= vValue
    else if vParam= 'glsl_shader_mame4' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame4:= vValue
    else if vParam= 'glsl_shader_mame5' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame5:= vValue
    else if vParam= 'glsl_shader_mame6' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame6:= vValue
    else if vParam= 'glsl_shader_mame7' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame7:= vValue
    else if vParam= 'glsl_shader_mame8' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame8:= vValue
    else if vParam= 'glsl_shader_mame9' then
      mame.Emu.Ini.OpenGL_glsl_shader_mame9:= vValue
    else if vParam= 'glsl_shader_screen0' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen0:= vValue
    else if vParam= 'glsl_shader_screen1' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen1:= vValue
    else if vParam= 'glsl_shader_screen2' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen2:= vValue
    else if vParam= 'glsl_shader_screen3' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen3:= vValue
    else if vParam= 'glsl_shader_screen4' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen4:= vValue
    else if vParam= 'glsl_shader_screen5' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen5:= vValue
    else if vParam= 'glsl_shader_screen6' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen6:= vValue
    else if vParam= 'glsl_shader_screen7' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen7:= vValue
    else if vParam= 'glsl_shader_screen8' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen8:= vValue
    else if vParam= 'glsl_shader_screen9' then
      mame.Emu.Ini.OpenGL_glsl_shader_screen9:= vValue
    //Osd Sound options
    else if vParam= 'sound' then
      mame.Emu.Ini.OSD_SOUND_sound:= vValue
    else if vParam= 'audio_latency' then
      mame.Emu.Ini.OSD_SOUND_audio_latency:= vValue
    //Portaudio options
    else if vParam= 'pa_api' then
      mame.Emu.Ini.PORTAUDIO_pa_api:= vValue
    else if vParam= 'pa_device' then
      mame.Emu.Ini.PORTAUDIO_pa_device:= vValue
    else if vParam= 'pa_latency' then
      mame.Emu.Ini.PORTAUDIO_pa_latency:= vValue
    //Bgfx post_processing options
    else if vParam= 'bgfx_path' then
      mame.Emu.Ini.BGFX_bgfx_path:= vValue
    else if vParam= 'bgfx_backend' then
      mame.Emu.Ini.BGFX_bgfx_backend:= vValue
    else if vParam= 'bgfx_debug' then
      mame.Emu.Ini.BGFX_bgfx_debug:= StrToBool(vValue)
    else if vParam= 'bgfx_screen_chains' then
      mame.Emu.Ini.BGFX_bgfx_screen_chains:= vValue
    else if vParam= 'bgfx_shadow_mask' then
      mame.Emu.Ini.BGFX_bgfx_shadow_mask:= vValue
    else if vParam= 'bgfx_avi_name' then
      mame.Emu.Ini.BGFX_bgfx_avi_name:= vValue
    //Windows performance options
    else if vParam= 'priority' then
      mame.Emu.Ini.WINDOWS_PERFORMANCE_priority:= vValue
    else if vParam= 'profile' then
      mame.Emu.Ini.WINDOWS_PERFORMANCE_profile:= vValue
    //Windows Video options
    else if vParam= 'menu' then
      mame.Emu.Ini.WINDOWS_VIDEO_menu:= StrToBool(vValue)
    //Direct3d Post_processing options
    else if vParam= 'hlslpath' then
      mame.Emu.Ini.DIRECT3D_hlslpath:= vValue
    else if vParam= 'hlsl_enable' then
      mame.Emu.Ini.DIRECT3D_hlsl_enable:= StrToBool(vValue)
    else if vParam= 'hlsl_oversampling' then
      mame.Emu.Ini.DIRECT3D_hlsl_oversampling:= StrToBool(vValue)
    else if vParam= 'hlsl_write' then
      mame.Emu.Ini.DIRECT3D_hlsl_write:= vValue
    else if vParam= 'hlsl_snap_width' then
      mame.Emu.Ini.DIRECT3D_hlsl_snap_width:= StrToInt(vValue)
    else if vParam= 'hlsl_snap_height' then
      mame.Emu.Ini.DIRECT3D_hlsl_snap_height:= StrToInt(vValue)
    else if vParam= 'shadow_mask_tile_mode' then
      mame.Emu.Ini.DIRECT3D_shadow_mask_tile_mode:= vValue
    else if vParam= 'shadow_mask_alpha' then
      mame.Emu.Ini.DIRECT3D_shadow_mask_alpha:= vValue
    else if vParam= 'shadow_mask_texture' then
      mame.Emu.Ini.DIRECT3D_shadow_mask_texture:= vValue
    else if vParam= 'shadow_mask_x_count' then
      mame.Emu.Ini.DIRECT3D_shadow_mask_x_count:= StrToInt(vValue)
    else if vParam= 'shadow_mask_y_count' then
      mame.Emu.Ini.DIRECT3D_shadow_mask_y_count:= StrToInt(vValue)
    else if vParam= 'shadow_mask_usize' then
      mame.Emu.Ini.DIRECT3D_shadow_mask_usize:= vValue
    else if vParam= 'shadow_mask_vsize' then
      mame.Emu.Ini.DIRECT3D_shadow_mask_vsize:= vValue
    else if vParam= 'shadow_mask_uoffset' then
      mame.Emu.Ini.DIRECT3D_shadow_mask_uoffset:= vValue
    else if vParam= 'shadow_mask_voffset' then
      mame.Emu.Ini.DIRECT3D_shadow_mask_voffset:= vValue
    else if vParam= 'distortion' then
      mame.Emu.Ini.DIRECT3D_distortion:= vValue
    else if vParam= 'cubic_distortion' then
      mame.Emu.Ini.DIRECT3D_cubic_distortion:= vValue
    else if vParam= 'distort_corner' then
      mame.Emu.Ini.DIRECT3D_distort_corner:= vValue
    else if vParam= 'round_corner' then
      mame.Emu.Ini.DIRECT3D_round_corner:= vValue
    else if vParam= 'smooth_border' then
      mame.Emu.Ini.DIRECT3D_smooth_border:= vValue
    else if vParam= 'reflection' then
      mame.Emu.Ini.DIRECT3D_reflection:= vValue
    else if vParam= 'vignetting' then
      mame.Emu.Ini.DIRECT3D_vignetting:= vValue
    else if vParam= 'scanline_alpha' then
      mame.Emu.Ini.DIRECT3D_scanline_alpha:= vValue
    else if vParam= 'scanline_size' then
      mame.Emu.Ini.DIRECT3D_scanline_size:= vValue
    else if vParam= 'scanline_height' then
      mame.Emu.Ini.DIRECT3D_scanline_height:= vValue
    else if vParam= 'scanline_variation' then
      mame.Emu.Ini.DIRECT3D_scanline_variation:= vValue
    else if vParam= 'scanline_bright_scale' then
      mame.Emu.Ini.DIRECT3D_scanline_bright_scale:= vValue
    else if vParam= 'scanline_bright_offset' then
      mame.Emu.Ini.DIRECT3D_scanline_bright_offset:= vValue
    else if vParam= 'scanline_jitter' then
      mame.Emu.Ini.DIRECT3D_scanline_jitter:= vValue
    else if vParam= 'hum_bar_alpha' then
      mame.Emu.Ini.DIRECT3D_hum_bar_alpha:= vValue
    else if vParam= 'defocus' then
      mame.Emu.Ini.DIRECT3D_defocus:= vValue
    else if vParam= 'converge_x' then
      mame.Emu.Ini.DIRECT3D_converge_x:= vValue
    else if vParam= 'converge_y' then
      mame.Emu.Ini.DIRECT3D_converge_y:= vValue
    else if vParam= 'radial_converge_x' then
      mame.Emu.Ini.DIRECT3D_radial_converge_x:= vValue
    else if vParam= 'radial_converge_y' then
      mame.Emu.Ini.DIRECT3D_radial_converge_y:= vValue
    else if vParam= 'red_ratio' then
      mame.Emu.Ini.DIRECT3D_red_ratio:= vValue
    else if vParam= 'grn_ratio' then
      mame.Emu.Ini.DIRECT3D_grn_ratio:= vValue
    else if vParam= 'blu_ratio' then
      mame.Emu.Ini.DIRECT3D_blu_ratio:= vValue
    else if vParam= 'saturation' then
      mame.Emu.Ini.DIRECT3D_saturation:= vValue
    else if vParam= 'offset' then
      mame.Emu.Ini.DIRECT3D_offset:= vValue
    else if vParam= 'scale' then
      mame.Emu.Ini.DIRECT3D_scale:= vValue
    else if vParam= 'power' then
      mame.Emu.Ini.DIRECT3D_power:= vValue
    else if vParam= 'floor' then
      mame.Emu.Ini.DIRECT3D_floor:= vValue
    else if vParam= 'phosphor_life' then
      mame.Emu.Ini.DIRECT3D_phosphor_life:= vValue
    //NTSC Post-processing options
    else if vParam= 'yiq_enable' then
      mame.Emu.Ini.NTSC_yiq_enable:= StrToBool(vValue)
    else if vParam= 'yiq_jitter' then
      mame.Emu.Ini.NTSC_yiq_jitter:= vValue
    else if vParam= 'yiq_cc' then
      mame.Emu.Ini.NTSC_yiq_cc:= vValue
    else if vParam= 'yiq_a' then
      mame.Emu.Ini.NTSC_yiq_a:= vValue
    else if vParam= 'yiq_b' then
      mame.Emu.Ini.NTSC_yiq_b:= vValue
    else if vParam= 'yiq_o' then
      mame.Emu.Ini.NTSC_yiq_o:= vValue
    else if vParam= 'yiq_p' then
      mame.Emu.Ini.NTSC_yiq_p:= vValue
    else if vParam= 'yiq_n' then
      mame.Emu.Ini.NTSC_yiq_n:= vValue
    else if vParam= 'yiq_y' then
      mame.Emu.Ini.NTSC_yiq_y:= vValue
    else if vParam= 'yiq_i' then
      mame.Emu.Ini.NTSC_yiq_i:= vValue
    else if vParam= 'yiq_q' then
      mame.Emu.Ini.NTSC_yiq_q:= vValue
    else if vParam= 'yiq_scan_time' then
      mame.Emu.Ini.NTSC_yiq_scan_time:= vValue
    else if vParam= 'yiq_phase_count' then
      mame.Emu.Ini.NTSC_yiq_phase_count:= vValue
    //Vector Post_processing options
    else if vParam= 'vector_beam_smooth' then
      mame.Emu.Ini.VECTOR_vector_beam_smooth:= vValue
    else if vParam= 'vector_length_scale' then
      mame.Emu.Ini.VECTOR_vector_length_scale:= vValue
    else if vParam= 'vector_length_ratio' then
      mame.Emu.Ini.VECTOR_vector_length_ratio:= vValue
    //Bloom Post_processing options
    else if vParam= 'bloom_blend_mode' then
      mame.Emu.Ini.BLOOM_bloom_blend_mode:= vValue
    else if vParam= 'bloom_scale' then
      mame.Emu.Ini.BLOOM_bloom_scale:= vValue
    else if vParam= 'bloom_overdrive' then
      mame.Emu.Ini.BLOOM_bloom_overdrive:= vValue
    else if vParam= 'bloom_lvl0_weight' then
      mame.Emu.Ini.BLOOM_bloom_lvl0_weight:= vValue
    else if vParam= 'bloom_lvl1_weight' then
      mame.Emu.Ini.BLOOM_bloom_lvl1_weight:= vValue
    else if vParam= 'bloom_lvl2_weight' then
      mame.Emu.Ini.BLOOM_bloom_lvl2_weight:= vValue
    else if vParam= 'bloom_lvl3_weight' then
      mame.Emu.Ini.BLOOM_bloom_lvl3_weight:= vValue
    else if vParam= 'bloom_lvl4_weight' then
      mame.Emu.Ini.BLOOM_bloom_lvl4_weight:= vValue
    else if vParam= 'bloom_lvl5_weight' then
      mame.Emu.Ini.BLOOM_bloom_lvl5_weight:= vValue
    else if vParam= 'bloom_lvl6_weight' then
      mame.Emu.Ini.BLOOM_bloom_lvl6_weight:= vValue
    else if vParam= 'bloom_lvl7_weight' then
      mame.Emu.Ini.BLOOM_bloom_lvl7_weight:= vValue
    else if vParam= 'bloom_lvl8_weight' then
      mame.Emu.Ini.BLOOM_bloom_lvl8_weight:= vValue
    //Fullscreen options
    else if vParam= 'triplebuffer' then
      mame.Emu.Ini.FULLSCREEN_triplebuffer:= StrToBool(vValue)
    else if vParam= 'full_screen_brightness' then
      mame.Emu.Ini.FULLSCREEN_full_screen_brightness:= vValue
    else if vParam= 'full_screen_contrast' then
      mame.Emu.Ini.FULLSCREEN_full_screen_contrast:= vValue
    else if vParam= 'full_screen_gamma' then
      mame.Emu.Ini.FULLSCREEN_full_screen_gamma:= vValue
    //Input Device options
    else if vParam= 'global_inputs' then
      mame.Emu.Ini.INPUT_DEVICE_global_inputs:= StrToInt(vValue)
    else if vParam= 'dual_lightgun' then
      mame.Emu.Ini.INPUT_DEVICE_dual_lightgun:= StrToBool(vValue)
    //Frontend Command options
    else if vParam= 'dtd' then
      mame.Emu.Ini.FRONTEND_COMMAND_dtd:= StrToInt(vValue);
  end;

begin
//DONE 1 -oNikos Kordas -cuEmu_Arcade_Mame: Get from ini all data and tranfer it to TEMU_MAME_INI for farther manipulation
  mame.Emu.Ini.CORE_SEARCH_rompath:= TStringList.Create;
  mame.Emu.Ini.CORE_SEARCH_inipath:= TStringList.Create;
  mame.Prog.Path:= extrafe.prog.Path+ 'emu\arcade\mame\config\';
  mame.Prog.Ini:= TIniFile.Create(mame.Prog.Path+ 'prog_mame.ini');
  mame.Prog.Data_Path:= mame.Prog.Ini.ReadString('PROG', 'Data_Path', mame.Prog.Data_Path);
  mame.Prog.Games_List:= mame.Prog.Ini.ReadString('PROG', 'Games_List', mame.Prog.Games_List);
  mame.Prog.Games_XML:= mame.Prog.Ini.ReadString('PROG', 'Games_XML', mame.Prog.Games_XML);
  mame.Prog.Images:= mame.Prog.Ini.ReadString('PROG', 'Images', mame.Prog.Images);
  mame.Prog.Sounds:= mame.Prog.Ini.ReadString('PROG', 'Sounds', mame.Prog.Sounds);

  mame.Emu.Name:= mame.Prog.Ini.ReadString('MAME', 'mame_name', mame.Emu.Name);
  mame.Emu.Path:= mame.Prog.Ini.ReadString('MAME', 'mame_path', mame.Emu.Path);
  mame.Emu.Ini_Path:= mame.Prog.Ini.ReadString('MAME', 'mame_ini_path', mame.Emu.Ini_Path);

  
  //Gameinit support
  mame.Support.GameInit:= TStringList.Create;

  AssignFile(vText, mame.Emu.Ini_Path+ 'mame.ini');
  Reset(vText);
  while not Eof(vText) do
    begin
      Readln(vText, vTLine);
      if (vTLine<> '#') and (vTLine<> '# CORE CONFIGURATION OPTIONS') and (vTLine<> '# CORE SEARCH PATH OPTIONS') and
        (vTLine<> '# CORE OUTPUT DIRECTORY OPTIONS') and (vTLine<> '# CORE STATE/PLAYBACK OPTIONS') and
        (vTLine<> '# CORE PERFORMANCE OPTIONS') and (vTLine<> '# CORE RENDER OPTIONS') and (vTLine<> '# CORE ROTATION OPTIONS') and
        (vTLine<> '# CORE ARTWORK OPTIONS') and (vTLine<> '# CORE SCREEN OPTIONS') and (vTLine<> '# CORE VECTOR OPTIONS') and
        (vTLine<> '# CORE SOUND OPTIONS') and (vTLine<> '# CORE INPUT OPTIONS') and (vTLine<> '# CORE INPUT AUTOMATIC ENABLE OPTIONS')and
        (vTLine<> '# CORE DEBUGGING OPTIONS') and (vTLine<> '# CORE COMM OPTIONS') and (vTLine<> '# CORE MISC OPTIONS') and
        (vTLine<> '# SCRIPTING OPTIONS') and (vTLine<> '# HTTP SERVER OPTIONS') and (vTLine<> '# OSD KEYBOARD MAPPING OPTIONS') and
        (vTLine<> '# OSD FONT OPTIONS') and (vTLine<> '# OSD OUTPUT OPTIONS') and (vTLine<> '# OSD INPUT OPTIONS') and
        (vTLine<> '# OSD DEBUGGING OPTIONS') and (vTLine<> '# OSD PERFORMANCE OPTIONS') and (vTLine<> '# OSD VIDEO OPTIONS') and
        (vTLine<> '# OSD PER-WINDOW VIDEO OPTIONS') and (vTLine<> '# OSD FULL SCREEN OPTIONS') and (vTLine<> '# OSD ACCELERATED VIDEO OPTIONS') and
        (vTLine<> '# OpenGL-SPECIFIC OPTIONS') and (vTLine<> '# OSD SOUND OPTIONS') and (vTLine<> '# PORTAUDIO OPTIONS') and
        (vTLine<> '# BGFX POST-PROCESSING OPTIONS') and (vTLine<> '# WINDOWS PERFORMANCE OPTIONS') and (vTLine<> '# WINDOWS VIDEO OPTIONS') and
        (vTLine<> '# DIRECT3D POST-PROCESSING OPTIONS') and (vTLine<> '# NTSC POST-PROCESSING OPTIONS') and (vTLine<> '# VECTOR POST-PROCESSING OPTIONS') and
        (vTLine<> '# BLOOM POST-PROCESSING OPTIONS') and (vTLine<> '# FULL SCREEN OPTIONS') and (vTLine<> '# INPUT DEVICE OPTIONS') and
        (vTLine<> '# FRONTEND COMMAND OPTIONS') and (vTLine<> '')  then
        begin
          vPos:= Pos(' ', vTLine);
          vT1:= Trim(Copy(vTLine, 0 , vPos+ 1));
          vT2:= Trim(Copy(vTLine, vPos+ 1, length(vTLine)- (vpos- 1)));
          uEmu_Arcade_Mame_SetValue_To_Ini(vT1, vT2);
        end;
    end;
  CloseFile(vText);
end;

procedure uEmu_Arcade_Mame_Ini_Save;
var
  vSaveMameIni: TStringList;

  function uEmu_Arcade_Mame_Ini_CheckBoolean(vBool: Boolean): WideString;
    begin
      if vBool= true then
        Result:= '1'
      else
        Result:= '0';
    end;
  function uEmu_Arcade_Mame_Ini_PathRoms(vPaths: TStringList): WideString;
    var
      vi: Integer;
      vRomPath: String;
    begin
      for vi:= 0 to vPaths.Count- 1 do
        begin
          vRomPath:= vPaths.Strings[vi];
          if vi= 0 then
            Result:= vRomPath
          else
            Result:= Result+ ';'+ vRomPath;
        end;
    end;
  function uEmu_Arcade_Mame_Ini_PathInis(vPaths: TStringList): WideString;
    var
      vi: Integer;
      vIniPath: String;
    begin
      for vi:= 0 to vPaths.Count- 1 do
        begin
          vIniPath:= vPaths.Strings[vi];
          if vi= 0 then
            Result:= vIniPath
          else
            Result:= Result+ ';'+ vIniPath;
        end;
    end;
begin
  vSaveMameIni:= TStringList.Create;
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE CONFIGURATION OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('readconfig                '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_CONFIGURATION_readconfig));
  vSaveMameIni.Add('writeconfig               '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_CONFIGURATION_writeconfig));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE SEARCH PATH OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('homepath                  '+ mame.Emu.Ini.CORE_SEARCH_homepath);
  vSaveMameIni.Add('rompath                   '+ uEmu_Arcade_Mame_Ini_PathRoms(mame.Emu.Ini.CORE_SEARCH_rompath));
  vSaveMameIni.Add('hashpath                  '+ mame.Emu.Ini.CORE_SEARCH_hashpath);
  vSaveMameIni.Add('samplepath                '+ mame.Emu.Ini.CORE_SEARCH_samplepath);
  vSaveMameIni.Add('artpath                   '+ mame.Emu.Ini.CORE_SEARCH_artpath);
  vSaveMameIni.Add('ctrlrpath                 '+ mame.Emu.Ini.CORE_SEARCH_ctrlrpath);
  vSaveMameIni.Add('inipath                   '+ uEmu_Arcade_Mame_Ini_PathInis(mame.Emu.Ini.CORE_SEARCH_inipath));
  vSaveMameIni.Add('fontpath                  '+ mame.Emu.Ini.CORE_SEARCH_fontpath);
  vSaveMameIni.Add('cheatpath                 '+ mame.Emu.Ini.CORE_SEARCH_cheatpath);
  vSaveMameIni.Add('crosshairpath             '+ mame.Emu.Ini.CORE_SEARCH_crosshairpath);
  vSaveMameIni.Add('pluginspath               '+ mame.Emu.Ini.CORE_SEARCH_pluginspath);
  vSaveMameIni.Add('languagepath              '+ mame.Emu.Ini.CORE_SEARCH_languagepath);
  vSaveMameIni.Add('swpath                    '+ mame.Emu.Ini.CORE_SEARCH_swpath);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE OUTPUT DIRECTORY OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('cfg_directory             '+ mame.Emu.Ini.CORE_OUTPUT_cfg_directory);
  vSaveMameIni.Add('nvram_directory           '+ mame.Emu.Ini.CORE_OUTPUT_nvram_directory);
  vSaveMameIni.Add('input_directory           '+ mame.Emu.Ini.CORE_OUTPUT_input_directory);
  vSaveMameIni.Add('state_directory           '+ mame.Emu.Ini.CORE_OUTPUT_state_directory);
  vSaveMameIni.Add('snapshot_directory        '+ mame.Emu.Ini.CORE_OUTPUT_snapshot_directory);
  vSaveMameIni.Add('diff_directory            '+ mame.Emu.Ini.CORE_OUTPUT_diff_directory);
  vSaveMameIni.Add('comment_directory         '+ mame.Emu.Ini.CORE_OUTPUT_comment_directory);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE STATE/PLAYBACK OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('state                     '+ mame.Emu.Ini.CORE_STATE_state);
  vSaveMameIni.Add('autosave                  '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_STATE_autosave));
  vSaveMameIni.Add('rewind                    '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_STATE_rewind));
  vSaveMameIni.Add('rewind_capacity           '+ IntToStr(mame.Emu.Ini.CORE_STATE_rewind_capacity));
  vSaveMameIni.Add('playback                  '+ mame.Emu.Ini.CORE_STATE_playback);
  vSaveMameIni.Add('record                    '+ mame.Emu.Ini.CORE_STATE_record);
  vSaveMameIni.Add('record_timecode           '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_STATE_record_timecode));
  vSaveMameIni.Add('exit_after_playback       '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_STATE_exit_after_playback));
  vSaveMameIni.Add('mngwrite                  '+ mame.Emu.Ini.CORE_STATE_mngwrite);
  vSaveMameIni.Add('aviwrite                  '+ mame.Emu.Ini.CORE_STATE_aviwrite);
  vSaveMameIni.Add('wavwrite                  '+ mame.Emu.Ini.CORE_STATE_wavwrite);
  vSaveMameIni.Add('snapname                  '+ mame.Emu.Ini.CORE_STATE_snapname);
  vSaveMameIni.Add('snapsize                  '+ mame.Emu.Ini.CORE_STATE_snapsize);
  vSaveMameIni.Add('snapview                  '+ mame.Emu.Ini.CORE_STATE_snapview);
  vSaveMameIni.Add('snapbilinear              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_STATE_snapbilinear));
  vSaveMameIni.Add('statename                 '+ mame.Emu.Ini.CORE_STATE_statename);
  vSaveMameIni.Add('burnin                    '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_STATE_burnin));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE PERFORMANCE OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('autoframeskip             '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_PERFORMANCE_autoframeskip));
  vSaveMameIni.Add('frameskip                 '+ IntToStr(mame.Emu.Ini.CORE_PERFORMANCE_frameskip));
  vSaveMameIni.Add('seconds_to_run            '+ FloatToStr(mame.Emu.Ini.CORE_PERFORMANCE_seconds_to_run));
  vSaveMameIni.Add('throttle                  '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_PERFORMANCE_throttle));
  vSaveMameIni.Add('sleep                     '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_PERFORMANCE_sleep));
  vSaveMameIni.Add('speed                     '+ mame.Emu.Ini.CORE_PERFORMANCE_speed);
  vSaveMameIni.Add('refreshspeed              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_PERFORMANCE_refreshspeed));
  if (mame.Emu.Name= 'arcade64.exe') or (mame.Emu.Name= 'arcade32.exe') then
    vSaveMameIni.Add('syncrefresh              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_PERFORMANCE_syncrefresh));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE RENDER OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('keepaspect                '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_RENDER_keepaspect));
  vSaveMameIni.Add('unevenstretch             '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_RENDER_unevenstretch));
  vSaveMameIni.Add('unevenstretchx            '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_RENDER_unevenstretchx));
  vSaveMameIni.Add('unevenstretchy            '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_RENDER_unevenstretchy));
  vSaveMameIni.Add('autostretchxy             '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_RENDER_autostretchxy));
  vSaveMameIni.Add('intoverscan               '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_RENDER_intoverscan));
  vSaveMameIni.Add('intscalex                 '+ FloatToStr(mame.Emu.Ini.CORE_RENDER_intscalex));
  vSaveMameIni.Add('intscaley                 '+ FloatToStr(mame.Emu.Ini.CORE_RENDER_intscaley));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE ROTATION OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('rotate                    '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ROTATION_rotate));
  vSaveMameIni.Add('ror                       '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ROTATION_ror));
  vSaveMameIni.Add('rol                       '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ROTATION_rol));
  vSaveMameIni.Add('autoror                   '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ROTATION_autoror));
  vSaveMameIni.Add('autorol                   '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ROTATION_autorol));
  vSaveMameIni.Add('flipx                     '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ROTATION_flipx));
  vSaveMameIni.Add('flipy                     '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ROTATION_flipy));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE ARTWORK OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('artwork_crop              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ARTWORK_artwork_crop));
  vSaveMameIni.Add('use_backdrops             '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ARTWORK_use_backdrops));
  vSaveMameIni.Add('use_overlays              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ARTWORK_use_overlays));
  vSaveMameIni.Add('use_bezels                '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ARTWORK_use_bezels));
  vSaveMameIni.Add('use_cpanels               '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ARTWORK_use_cpanels));
  vSaveMameIni.Add('use_marquees              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_ARTWORK_use_marquees));
  vSaveMameIni.Add('fallback_artwork          '+ mame.Emu.Ini.CORE_ARTWORK_fallback_artwork);
  vSaveMameIni.Add('override_artwork          '+ mame.Emu.Ini.CORE_ARTWORK_override_artwork);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE SCREEN OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('brightness                '+ mame.Emu.Ini.CORE_SCREEN_brightness);
  vSaveMameIni.Add('contrast                  '+ mame.Emu.Ini.CORE_SCREEN_contrast);
  vSaveMameIni.Add('gamma                     '+ mame.Emu.Ini.CORE_SCREEN_gamma);
  vSaveMameIni.Add('pause_brightness          '+ mame.Emu.Ini.CORE_SCREEN_pause_brightness);
  vSaveMameIni.Add('effect                    '+ mame.Emu.Ini.CORE_SCREEN_effect);
  if (mame.Emu.Name= 'arcade64.exe') or (mame.Emu.Name= 'arcade32.exe') then
    vSaveMameIni.Add('widestretch               '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_SCREEN_widestretch));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE VECTOR OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('beam_width_min            '+ mame.Emu.Ini.CORE_VECTOR_beam_width_min);
  vSaveMameIni.Add('beam_width_max            '+ mame.Emu.Ini.CORE_VECTOR_beam_width_max);
  vSaveMameIni.Add('beam_intensity_weight     '+ mame.Emu.Ini.CORE_VECTOR_beam_intensity_weight);
  vSaveMameIni.Add('flicker                   '+ mame.Emu.Ini.CORE_VECTOR_flicker);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE SOUND OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('samplerate                '+ mame.Emu.Ini.CORE_SOUND_samplerate);
  vSaveMameIni.Add('samples                   '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_SOUND_samples));
  vSaveMameIni.Add('volume                    '+ mame.Emu.Ini.CORE_SOUND_volume);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE INPUT OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('coin_lockout              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_coin_lockout));
  vSaveMameIni.Add('ctrlr                     '+ mame.Emu.Ini.CORE_INPUT_ctrlr);
  vSaveMameIni.Add('mouse                     '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_mouse));
  vSaveMameIni.Add('joystick                  '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_joystick));
  vSaveMameIni.Add('lightgun                  '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_lightgun));
  vSaveMameIni.Add('multikeyboard             '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_multikeyboard));
  vSaveMameIni.Add('multimouse                '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_multimouse));
  vSaveMameIni.Add('steadykey                 '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_steadykey));
  vSaveMameIni.Add('ui_active                 '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_ui_active));
  vSaveMameIni.Add('offscreen_reload          '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_offscreen_reload));
  vSaveMameIni.Add('joystick_map              '+ mame.Emu.Ini.CORE_INPUT_joystick_map);
  vSaveMameIni.Add('joystick_deadzone         '+ mame.Emu.Ini.CORE_INPUT_joystick_deadzone);
  vSaveMameIni.Add('joystick_saturation       '+ mame.Emu.Ini.CORE_INPUT_joystick_saturation);
  vSaveMameIni.Add('natural                   '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_natural));
  vSaveMameIni.Add('joystick_contradictory    '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_joystick_contradictory));
  vSaveMameIni.Add('coin_impulse              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_INPUT_coin_impulse));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE INPUT AUTOMATIC ENABLE OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('paddle_device             '+ mame.Emu.Ini.CORE_INPUT_AUTOMATIC_paddle_device);
  vSaveMameIni.Add('adstick_device            '+ mame.Emu.Ini.CORE_INPUT_AUTOMATIC_adstick_device);
  vSaveMameIni.Add('pedal_device              '+ mame.Emu.Ini.CORE_INPUT_AUTOMATIC_pedal_device);
  vSaveMameIni.Add('dial_device               '+ mame.Emu.Ini.CORE_INPUT_AUTOMATIC_dial_device);
  vSaveMameIni.Add('trackball_device          '+ mame.Emu.Ini.CORE_INPUT_AUTOMATIC_trackball_device);
  vSaveMameIni.Add('lightgun_device           '+ mame.Emu.Ini.CORE_INPUT_AUTOMATIC_lightgun_device);
  vSaveMameIni.Add('positional_device         '+ mame.Emu.Ini.CORE_INPUT_AUTOMATIC_positional_device);
  vSaveMameIni.Add('mouse_device              '+ mame.Emu.Ini.CORE_INPUT_AUTOMATIC_mouse_device);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE DEBUGGING OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('verbose                   '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_DEBUGGING_verbose));
  vSaveMameIni.Add('log                       '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_DEBUGGING_log));
  vSaveMameIni.Add('oslog                     '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_DEBUGGING_oslog));
  vSaveMameIni.Add('debug                     '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_DEBUGGING_debug));
  vSaveMameIni.Add('update_in_pause           '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_DEBUGGING_update_in_pause));
  vSaveMameIni.Add('debugscript               '+ mame.Emu.Ini.CORE_DEBUGGING_debugscript);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE COMM OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('comm_localhost            '+ mame.Emu.Ini.CORE_COMM_comm_localhost);
  vSaveMameIni.Add('comm_localport            '+ mame.Emu.Ini.CORE_COMM_comm_localport);
  vSaveMameIni.Add('comm_remotehost           '+ mame.Emu.Ini.CORE_COMM_comm_remotehost);
  vSaveMameIni.Add('comm_remoteport           '+ mame.Emu.Ini.CORE_COMM_comm_remoteport);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# CORE MISC OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('drc                       '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_MISC_drc));
  vSaveMameIni.Add('drc_use_c                 '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_MISC_drc_use_c));
  vSaveMameIni.Add('drc_log_uml               '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_MISC_drc_log_uml));
  vSaveMameIni.Add('drc_log_native            '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_MISC_drc_log_native));
  vSaveMameIni.Add('bios                      '+ mame.Emu.Ini.CORE_MISC_bios);
  vSaveMameIni.Add('cheat                     '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_MISC_cheat));
  vSaveMameIni.Add('skip_gameinfo             '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_MISC_skip_gameinfo));
  vSaveMameIni.Add('uifont                    '+ mame.Emu.Ini.CORE_MISC_uifont);
  vSaveMameIni.Add('ui                        '+ mame.Emu.Ini.CORE_MISC_ui);
  vSaveMameIni.Add('ramsize                   '+ mame.Emu.Ini.CORE_MISC_ramsize);
  vSaveMameIni.Add('confirm_quit              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_MISC_confirm_quit));
  vSaveMameIni.Add('ui_mouse                  '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_MISC_ui_mouse));
  vSaveMameIni.Add('language                  '+ mame.Emu.Ini.CORE_MISC_language);
  vSaveMameIni.Add('nvram_save                '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.CORE_MISC_nvram_save));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# SCRIPTING OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('autoboot_command          '+ mame.Emu.Ini.SCRIPTING_autoboot_command);
  vSaveMameIni.Add('autoboot_delay            '+ mame.Emu.Ini.SCRIPTING_autoboot_delay);
  vSaveMameIni.Add('autoboot_script           '+ mame.Emu.Ini.SCRIPTING_autoboot_script);
  vSaveMameIni.Add('console                   '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.SCRIPTING_console));
  vSaveMameIni.Add('plugins                   '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.SCRIPTING_plugins));
  vSaveMameIni.Add('plugin                    '+ mame.Emu.Ini.SCRIPTING_plugin);
  vSaveMameIni.Add('noplugin                  '+ mame.Emu.Ini.SCRIPTING_noplugin);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# HTTP SERVER OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('http                      '+ mame.Emu.Ini.HTTP_http);
  vSaveMameIni.Add('http_port                 '+ mame.Emu.Ini.HTTP_port);
  vSaveMameIni.Add('http_root                 '+ mame.Emu.Ini.HTTP_root);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD KEYBOARD MAPPING OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('uimodekey                 '+ mame.Emu.Ini.OSD_KEYBOARD_uimodekey);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD FONT OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('uifontprovider            '+ mame.Emu.Ini.OSD_FONT_uifontprovider);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD OUTPUT OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('output                    '+ mame.Emu.Ini.OSD_OUTPUT_output);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD INPUT OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('keyboardprovider          '+ mame.Emu.Ini.OSD_INPUT_keyboardprovider);
  vSaveMameIni.Add('mouseprovider             '+ mame.Emu.Ini.OSD_INPUT_mouseprovider);
  vSaveMameIni.Add('lightgunprovider          '+ mame.Emu.Ini.OSD_INPUT_lightgunprovider);
  vSaveMameIni.Add('joystickprovider          '+ mame.Emu.Ini.OSD_INPUT_joystickprovider);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD DEBUGGING OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('debugger                  '+ mame.Emu.Ini.OSD_DEBUGGING_debugger);
  vSaveMameIni.Add('debugger_font             '+ mame.Emu.Ini.OSD_DEBUGGING_debugger_font);
  vSaveMameIni.Add('debugger_font_size        '+ IntToStr(mame.Emu.Ini.OSD_DEBUGGING_debugger_font_size));
  vSaveMameIni.Add('watchdog                  '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OSD_DEBUGGING_watchdog));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD PERFORMANCE OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('numprocessors             '+ mame.Emu.Ini.OSD_PERFORMANCE_numprocessors);
  vSaveMameIni.Add('bench                     '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OSD_PERFORMANCE_bench));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD VIDEO OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('video                     '+ mame.Emu.Ini.OSD_VIDEO_video);
  vSaveMameIni.Add('numscreens                '+ IntToStr(mame.Emu.Ini.OSD_VIDEO_numscreens));
  vSaveMameIni.Add('window                    '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OSD_VIDEO_window));
  vSaveMameIni.Add('maximize                  '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OSD_VIDEO_maximize));
  vSaveMameIni.Add('waitvsync                 '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OSD_VIDEO_waitvsync));
  vSaveMameIni.Add('syncrefresh               '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OSD_VIDEO_syncrefresh));
  vSaveMameIni.Add('monitorprovider           '+ mame.Emu.Ini.OSD_VIDEO_monitorprovider);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD PER-WINDOW VIDEO OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('screen                    '+ mame.Emu.Ini.OSD_PER_WINDOW_screen);
  vSaveMameIni.Add('aspect                    '+ mame.Emu.Ini.OSD_PER_WINDOW_aspect);
  vSaveMameIni.Add('resolution                '+ mame.Emu.Ini.OSD_PER_WINDOW_resolution);
  vSaveMameIni.Add('view                      '+ mame.Emu.Ini.OSD_PER_WINDOW_view);
  vSaveMameIni.Add('screen0                   '+ mame.Emu.Ini.OSD_PER_WINDOW_screen0);
  vSaveMameIni.Add('aspect0                   '+ mame.Emu.Ini.OSD_PER_WINDOW_aspect0);
  vSaveMameIni.Add('resolution0               '+ mame.Emu.Ini.OSD_PER_WINDOW_resolution0);
  vSaveMameIni.Add('view0                     '+ mame.Emu.Ini.OSD_PER_WINDOW_view0);
  vSaveMameIni.Add('screen1                   '+ mame.Emu.Ini.OSD_PER_WINDOW_screen1);
  vSaveMameIni.Add('aspect1                   '+ mame.Emu.Ini.OSD_PER_WINDOW_aspect1);
  vSaveMameIni.Add('resolution1               '+ mame.Emu.Ini.OSD_PER_WINDOW_resolution1);
  vSaveMameIni.Add('view1                     '+ mame.Emu.Ini.OSD_PER_WINDOW_view1);
  vSaveMameIni.Add('screen2                   '+ mame.Emu.Ini.OSD_PER_WINDOW_screen2);
  vSaveMameIni.Add('aspect2                   '+ mame.Emu.Ini.OSD_PER_WINDOW_aspect2);
  vSaveMameIni.Add('resolution2               '+ mame.Emu.Ini.OSD_PER_WINDOW_resolution2);
  vSaveMameIni.Add('view2                     '+ mame.Emu.Ini.OSD_PER_WINDOW_view2);
  vSaveMameIni.Add('screen3                   '+ mame.Emu.Ini.OSD_PER_WINDOW_screen3);
  vSaveMameIni.Add('aspect3                   '+ mame.Emu.Ini.OSD_PER_WINDOW_aspect3);
  vSaveMameIni.Add('resolution3               '+ mame.Emu.Ini.OSD_PER_WINDOW_resolution3);
  vSaveMameIni.Add('view3                     '+ mame.Emu.Ini.OSD_PER_WINDOW_view3);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD FULL SCREEN OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('switchres                 '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OSD_FULLSCREEN_switchres));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD ACCELERATED VIDEO OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('filter                    '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OSD_ACCELERATED_filter));
  vSaveMameIni.Add('prescale                  '+ FloatToStr(mame.Emu.Ini.OSD_ACCELERATED_prescale));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OpenGL-SPECIFIC OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('gl_forcepow2texture       '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OpenGL_gl_forcepow2texture));
  vSaveMameIni.Add('gl_notexturerect          '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OpenGL_gl_notexturerect));
  vSaveMameIni.Add('gl_vbo                    '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OpenGL_gl_vbo));
  vSaveMameIni.Add('gl_pbo                    '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OpenGL_gl_pbo));
  vSaveMameIni.Add('gl_glsl                   '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OpenGL_gl_glsl));
  if (mame.Emu.Name= 'arcade64.exe') or (mame.Emu.Name= 'arcade32.exe') then
    vSaveMameIni.Add('gl_glsl_sync              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.OpenGL_gl_glsl_sync));
  vSaveMameIni.Add('gl_glsl_filter            '+ IntToStr(mame.Emu.Ini.OpenGL_gl_glsl_filter));
  vSaveMameIni.Add('glsl_shader_mame0         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame0);
  vSaveMameIni.Add('glsl_shader_mame1         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame1);
  vSaveMameIni.Add('glsl_shader_mame2         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame2);
  vSaveMameIni.Add('glsl_shader_mame3         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame3);
  vSaveMameIni.Add('glsl_shader_mame4         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame4);
  vSaveMameIni.Add('glsl_shader_mame5         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame5);
  vSaveMameIni.Add('glsl_shader_mame6         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame6);
  vSaveMameIni.Add('glsl_shader_mame7         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame7);
  vSaveMameIni.Add('glsl_shader_mame8         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame8);
  vSaveMameIni.Add('glsl_shader_mame9         '+ mame.Emu.Ini.OpenGL_glsl_shader_mame9);
  vSaveMameIni.Add('glsl_shader_screen0       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen0);
  vSaveMameIni.Add('glsl_shader_screen1       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen1);
  vSaveMameIni.Add('glsl_shader_screen2       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen2);
  vSaveMameIni.Add('glsl_shader_screen3       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen3);
  vSaveMameIni.Add('glsl_shader_screen4       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen4);
  vSaveMameIni.Add('glsl_shader_screen5       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen5);
  vSaveMameIni.Add('glsl_shader_screen6       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen6);
  vSaveMameIni.Add('glsl_shader_screen7       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen7);
  vSaveMameIni.Add('glsl_shader_screen8       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen8);
  vSaveMameIni.Add('glsl_shader_screen9       '+ mame.Emu.Ini.OpenGL_glsl_shader_screen9);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# OSD SOUND OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('sound                     '+ mame.Emu.Ini.OSD_SOUND_sound);
  vSaveMameIni.Add('audio_latency             '+ mame.Emu.Ini.OSD_SOUND_audio_latency);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# PORTAUDIO OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('pa_api                    '+ mame.Emu.Ini.PORTAUDIO_pa_api);
  vSaveMameIni.Add('pa_device                 '+ mame.Emu.Ini.PORTAUDIO_pa_device);
  vSaveMameIni.Add('pa_latency                '+ mame.Emu.Ini.PORTAUDIO_pa_latency);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# BGFX POST-PROCESSING OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('bgfx_path                 '+ mame.Emu.Ini.BGFX_bgfx_path);
  vSaveMameIni.Add('bgfx_backend              '+ mame.Emu.Ini.BGFX_bgfx_backend);
  vSaveMameIni.Add('bgfx_debug                '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.BGFX_bgfx_debug));
  vSaveMameIni.Add('bgfx_screen_chains        '+ mame.Emu.Ini.BGFX_bgfx_screen_chains);
  vSaveMameIni.Add('bgfx_shadow_mask          '+ mame.Emu.Ini.BGFX_bgfx_shadow_mask);
  vSaveMameIni.Add('bgfx_avi_name             '+ mame.Emu.Ini.BGFX_bgfx_avi_name);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# WINDOWS PERFORMANCE OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('priority                  '+ mame.Emu.Ini.WINDOWS_PERFORMANCE_priority);
  vSaveMameIni.Add('profile                   '+ mame.Emu.Ini.WINDOWS_PERFORMANCE_profile);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# WINDOWS VIDEO OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('menu                      '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.WINDOWS_VIDEO_menu));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# DIRECT3D POST-PROCESSING OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('hlslpath                  '+ mame.Emu.Ini.DIRECT3D_hlslpath);
  vSaveMameIni.Add('hlsl_enable               '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.DIRECT3D_hlsl_enable));
  vSaveMameIni.Add('hlsl_oversampling         '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.DIRECT3D_hlsl_oversampling));
  vSaveMameIni.Add('hlsl_write                '+ mame.Emu.Ini.DIRECT3D_hlsl_write);
  vSaveMameIni.Add('hlsl_snap_width           '+ IntToStr(mame.Emu.Ini.DIRECT3D_hlsl_snap_width));
  vSaveMameIni.Add('hlsl_snap_height          '+ IntToStr(mame.Emu.Ini.DIRECT3D_hlsl_snap_height));
  vSaveMameIni.Add('shadow_mask_tile_mode     '+ mame.Emu.Ini.DIRECT3D_shadow_mask_tile_mode);
  vSaveMameIni.Add('shadow_mask_alpha         '+ mame.Emu.Ini.DIRECT3D_shadow_mask_alpha);
  vSaveMameIni.Add('shadow_mask_texture       '+ mame.Emu.Ini.DIRECT3D_shadow_mask_texture);
  vSaveMameIni.Add('shadow_mask_x_count       '+ IntToStr(mame.Emu.Ini.DIRECT3D_shadow_mask_x_count));
  vSaveMameIni.Add('shadow_mask_y_count       '+ IntToStr(mame.Emu.Ini.DIRECT3D_shadow_mask_y_count));
  vSaveMameIni.Add('shadow_mask_usize         '+ mame.Emu.Ini.DIRECT3D_shadow_mask_usize);
  vSaveMameIni.Add('shadow_mask_vsize         '+ mame.Emu.Ini.DIRECT3D_shadow_mask_vsize);
  vSaveMameIni.Add('shadow_mask_uoffset       '+ mame.Emu.Ini.DIRECT3D_shadow_mask_uoffset);
  vSaveMameIni.Add('shadow_mask_voffset       '+ mame.Emu.Ini.DIRECT3D_shadow_mask_voffset);
  vSaveMameIni.Add('distortion                '+ mame.Emu.Ini.DIRECT3D_distortion);
  vSaveMameIni.Add('cubic_distortion          '+ mame.Emu.Ini.DIRECT3D_cubic_distortion);
  vSaveMameIni.Add('distort_corner            '+ mame.Emu.Ini.DIRECT3D_distort_corner);
  vSaveMameIni.Add('round_corner              '+ mame.Emu.Ini.DIRECT3D_round_corner);
  vSaveMameIni.Add('smooth_border             '+ mame.Emu.Ini.DIRECT3D_smooth_border);
  vSaveMameIni.Add('reflection                '+ mame.Emu.Ini.DIRECT3D_reflection);
  vSaveMameIni.Add('vignetting                '+ mame.Emu.Ini.DIRECT3D_vignetting);
  vSaveMameIni.Add('scanline_alpha            '+ mame.Emu.Ini.DIRECT3D_scanline_alpha);
  vSaveMameIni.Add('scanline_size             '+ mame.Emu.Ini.DIRECT3D_scanline_size);
  vSaveMameIni.Add('scanline_height           '+ mame.Emu.Ini.DIRECT3D_scanline_height);
  vSaveMameIni.Add('scanline_variation        '+ mame.Emu.Ini.DIRECT3D_scanline_variation);
  vSaveMameIni.Add('scanline_bright_scale     '+ mame.Emu.Ini.DIRECT3D_scanline_bright_scale);
  vSaveMameIni.Add('scanline_bright_offset    '+ mame.Emu.Ini.DIRECT3D_scanline_bright_offset);
  vSaveMameIni.Add('scanline_jitter           '+ mame.Emu.Ini.DIRECT3D_scanline_jitter);
  vSaveMameIni.Add('hum_bar_alpha             '+ mame.Emu.Ini.DIRECT3D_hum_bar_alpha);
  vSaveMameIni.Add('defocus                   '+ mame.Emu.Ini.DIRECT3D_defocus);
  vSaveMameIni.Add('converge_x                '+ mame.Emu.Ini.DIRECT3D_converge_x);
  vSaveMameIni.Add('converge_y                '+ mame.Emu.Ini.DIRECT3D_converge_y);
  vSaveMameIni.Add('radial_converge_x         '+ mame.Emu.Ini.DIRECT3D_radial_converge_x);
  vSaveMameIni.Add('radial_converge_y         '+ mame.Emu.Ini.DIRECT3D_radial_converge_y);
  vSaveMameIni.Add('red_ratio                 '+ mame.Emu.Ini.DIRECT3D_red_ratio);
  vSaveMameIni.Add('grn_ratio                 '+ mame.Emu.Ini.DIRECT3D_grn_ratio);
  vSaveMameIni.Add('blu_ratio                 '+ mame.Emu.Ini.DIRECT3D_blu_ratio);
  vSaveMameIni.Add('saturation                '+ mame.Emu.Ini.DIRECT3D_saturation);
  vSaveMameIni.Add('offset                    '+ mame.Emu.Ini.DIRECT3D_offset);
  vSaveMameIni.Add('scale                     '+ mame.Emu.Ini.DIRECT3D_scale);
  vSaveMameIni.Add('power                     '+ mame.Emu.Ini.DIRECT3D_power);
  vSaveMameIni.Add('floor                     '+ mame.Emu.Ini.DIRECT3D_floor);
  vSaveMameIni.Add('phosphor_life             '+ mame.Emu.Ini.DIRECT3D_phosphor_life);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# NTSC POST-PROCESSING OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('yiq_enable                '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.NTSC_yiq_enable));
  vSaveMameIni.Add('yiq_jitter                '+ mame.Emu.Ini.NTSC_yiq_jitter);
  vSaveMameIni.Add('yiq_cc                    '+ mame.Emu.Ini.NTSC_yiq_cc);
  vSaveMameIni.Add('yiq_a                     '+ mame.Emu.Ini.NTSC_yiq_a);
  vSaveMameIni.Add('yiq_b                     '+ mame.Emu.Ini.NTSC_yiq_b);
  vSaveMameIni.Add('yiq_o                     '+ mame.Emu.Ini.NTSC_yiq_o);
  vSaveMameIni.Add('yiq_p                     '+ mame.Emu.Ini.NTSC_yiq_p);
  vSaveMameIni.Add('yiq_n                     '+ mame.Emu.Ini.NTSC_yiq_n);
  vSaveMameIni.Add('yiq_y                     '+ mame.Emu.Ini.NTSC_yiq_y);
  vSaveMameIni.Add('yiq_i                     '+ mame.Emu.Ini.NTSC_yiq_i);
  vSaveMameIni.Add('yiq_q                     '+ mame.Emu.Ini.NTSC_yiq_q);
  vSaveMameIni.Add('yiq_scan_time             '+ mame.Emu.Ini.NTSC_yiq_scan_time);
  vSaveMameIni.Add('yiq_phase_count           '+ mame.Emu.Ini.NTSC_yiq_phase_count);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# VECTOR POST-PROCESSING OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('vector_beam_smooth        '+ mame.Emu.Ini.VECTOR_vector_beam_smooth);
  vSaveMameIni.Add('vector_length_scale       '+ mame.Emu.Ini.VECTOR_vector_length_scale);
  vSaveMameIni.Add('vector_length_ratio       '+ mame.Emu.Ini.VECTOR_vector_length_ratio);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# BLOOM POST-PROCESSING OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('bloom_blend_mode          '+ mame.Emu.Ini.BLOOM_bloom_blend_mode);
  vSaveMameIni.Add('bloom_scale               '+ mame.Emu.Ini.BLOOM_bloom_scale);
  vSaveMameIni.Add('bloom_overdrive           '+ mame.Emu.Ini.BLOOM_bloom_overdrive);
  vSaveMameIni.Add('bloom_lvl0_weight         '+ mame.Emu.Ini.BLOOM_bloom_lvl0_weight);
  vSaveMameIni.Add('bloom_lvl1_weight         '+ mame.Emu.Ini.BLOOM_bloom_lvl1_weight);
  vSaveMameIni.Add('bloom_lvl2_weight         '+ mame.Emu.Ini.BLOOM_bloom_lvl2_weight);
  vSaveMameIni.Add('bloom_lvl3_weight         '+ mame.Emu.Ini.BLOOM_bloom_lvl3_weight);
  vSaveMameIni.Add('bloom_lvl4_weight         '+ mame.Emu.Ini.BLOOM_bloom_lvl4_weight);
  vSaveMameIni.Add('bloom_lvl5_weight         '+ mame.Emu.Ini.BLOOM_bloom_lvl5_weight);
  vSaveMameIni.Add('bloom_lvl6_weight         '+ mame.Emu.Ini.BLOOM_bloom_lvl6_weight);
  vSaveMameIni.Add('bloom_lvl7_weight         '+ mame.Emu.Ini.BLOOM_bloom_lvl7_weight);
  vSaveMameIni.Add('bloom_lvl8_weight         '+ mame.Emu.Ini.BLOOM_bloom_lvl8_weight);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# FULL SCREEN OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('triplebuffer              '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.FULLSCREEN_triplebuffer));
  vSaveMameIni.Add('full_screen_brightness    '+ mame.Emu.Ini.FULLSCREEN_full_screen_brightness);
  vSaveMameIni.Add('full_screen_contrast      '+ mame.Emu.Ini.FULLSCREEN_full_screen_contrast);
  vSaveMameIni.Add('full_screen_gamma         '+ mame.Emu.Ini.FULLSCREEN_full_screen_gamma);
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# INPUT DEVICE OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('global_inputs             '+ IntToStr(mame.Emu.Ini.INPUT_DEVICE_global_inputs));
  vSaveMameIni.Add('dual_lightgun             '+ uEmu_Arcade_Mame_Ini_CheckBoolean(mame.Emu.Ini.INPUT_DEVICE_dual_lightgun));
  vSaveMameIni.Add('');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('# FRONTEND COMMAND OPTIONS');
  vSaveMameIni.Add('#');
  vSaveMameIni.Add('dtd                       '+ IntToStr(mame.Emu.Ini.FRONTEND_COMMAND_dtd));
  vSaveMameIni.SaveToFile(mame.Emu.Ini_Path+ 'mame.ini');
  vSaveMameIni.Free;
end;

procedure uEmu_Arcade_Mame_Ini_Free;
begin

end;

procedure uEmu_Arcade_Mame_Ini_GetMediaPaths;
begin
//DONE 1 -oNikos Kordas -cuEmu_Arcade_Mame: Get Media paths before entering emu scene
  mame.Emu.Media.Artworks:= mame.Prog.Ini.ReadString('MEDIA', 'Artworks_Path', mame.Emu.Media.Artworks);
  mame.Emu.Media.Cabinets:= mame.Prog.Ini.ReadString('MEDIA', 'Cabinets_Path', mame.Emu.Media.Cabinets);
  mame.Emu.Media.Control_Panels:= mame.Prog.Ini.ReadString('MEDIA', 'Control_Panels_Path', mame.Emu.Media.Control_Panels);
  mame.Emu.Media.Covers:= mame.Prog.Ini.ReadString('MEDIA', 'Covers_Path', mame.Emu.Media.Covers);
  mame.Emu.Media.Flyers:= mame.Prog.Ini.ReadString('MEDIA', 'Flyers_Path', mame.Emu.Media.Flyers);
  mame.Emu.Media.Fanart:= mame.Prog.Ini.ReadString('MEDIA', 'Fanart_Path', mame.Emu.Media.Fanart);
  mame.Emu.Media.Game_Over:= mame.Prog.Ini.ReadString('MEDIA', 'Game_Over_Path', mame.Emu.Media.Game_Over);
  mame.Emu.Media.Icons:= mame.Prog.Ini.ReadString('MEDIA', 'Icons_Path', mame.Emu.Media.Icons);
  mame.Emu.Media.Manuals:= mame.Prog.Ini.ReadString('MEDIA', 'Manuals_Path', mame.Emu.Media.Manuals);
  mame.Emu.Media.Marquees:= mame.Prog.Ini.ReadString('MEDIA', 'Marquees_Path', mame.Emu.Media.Marquees);
  mame.Emu.Media.Pcbs:= mame.Prog.Ini.ReadString('MEDIA', 'Pcbs_Path', mame.Emu.Media.Pcbs);
  mame.Emu.Media.Snapshots:= mame.Prog.Ini.ReadString('MEDIA', 'Snapshots_Path', mame.Emu.Media.Snapshots);
  mame.Emu.Media.Titles:= mame.Prog.Ini.ReadString('MEDIA', 'Titles_Path', mame.Emu.Media.Titles);
  mame.Emu.Media.Artwork_Preview:= mame.Prog.Ini.ReadString('MEDIA', 'Artwork_Preview_Path', mame.Emu.Media.Artwork_Preview);
  mame.Emu.Media.Bosses:= mame.Prog.Ini.ReadString('MEDIA', 'Bosses_Path', mame.Emu.Media.Bosses);
  mame.Emu.Media.Ends:= mame.Prog.Ini.ReadString('MEDIA', 'Ends_Path', mame.Emu.Media.Ends);
  mame.Emu.Media.How_To:= mame.Prog.Ini.ReadString('MEDIA', 'How_To_Path', mame.Emu.Media.How_To);
  mame.Emu.Media.Logos:= mame.Prog.Ini.ReadString('MEDIA', 'Logos_Path', mame.Emu.Media.Logos);
  mame.Emu.Media.Scores:= mame.Prog.Ini.ReadString('MEDIA', 'Scores_Path', mame.Emu.Media.Scores);
  mame.Emu.Media.Selects:= mame.Prog.Ini.ReadString('MEDIA', 'Selects_Path', mame.Emu.Media.Selects);
  mame.Emu.Media.Stamps:= mame.Prog.Ini.ReadString('MEDIA', 'Stamps_Path', mame.Emu.Media.Stamps);
  mame.Emu.Media.Versus:= mame.Prog.Ini.ReadString('MEDIA', 'Versus_Path', mame.Emu.Media.Versus);
  mame.Emu.Media.Warnings:= mame.Prog.Ini.ReadString('MEDIA', 'Warnings_Path', mame.Emu.Media.Warnings);
  mame.Emu.Media.Soundtracks:= mame.Prog.Ini.ReadString('MEDIA', 'Soundtracks_Path', mame.Emu.Media.Soundtracks);
  mame.Emu.Media.Support_Files:= mame.Prog.Ini.ReadString('MEDIA', 'Support_Files_Path', mame.Emu.Media.Support_Files);
  mame.Emu.Media.Videos:= mame.Prog.Ini.ReadString('MEDIA', 'Videos_Path', mame.Emu.Media.Videos);
end;

procedure uEmu_Arcade_Mame_Ini_SaveMediaPaths;
begin
  mame.Prog.Ini.WriteString('MEDIA', 'Artworks_Path', mame.Emu.Media.Artworks);
  mame.Prog.Ini.WriteString('MEDIA', 'Cabinets_Path', mame.Emu.Media.Cabinets);
  mame.Prog.Ini.WriteString('MEDIA', 'Control_Panels_Path', mame.Emu.Media.Control_Panels);
  mame.Prog.Ini.WriteString('MEDIA', 'Covers_Path', mame.Emu.Media.Covers);
  mame.Prog.Ini.WriteString('MEDIA', 'Flyers_Path', mame.Emu.Media.Flyers);
  mame.Prog.Ini.WriteString('MEDIA', 'Fanart_Path', mame.Emu.Media.Fanart);
  mame.Prog.Ini.WriteString('MEDIA', 'Game_Over_Path', mame.Emu.Media.Game_Over);
  mame.Prog.Ini.WriteString('MEDIA', 'Icons_Path', mame.Emu.Media.Icons);
  mame.Prog.Ini.WriteString('MEDIA', 'Manuals_Path', mame.Emu.Media.Manuals);
  mame.Prog.Ini.WriteString('MEDIA', 'Marquees_Path', mame.Emu.Media.Marquees);
  mame.Prog.Ini.WriteString('MEDIA', 'Pcbs_Path', mame.Emu.Media.Pcbs);
  mame.Prog.Ini.WriteString('MEDIA', 'Snapshots_Path', mame.Emu.Media.Snapshots);
  mame.Prog.Ini.WriteString('MEDIA', 'Titles_Path', mame.Emu.Media.Titles);
  mame.Prog.Ini.WriteString('MEDIA', 'Artwork_Preview_Path', mame.Emu.Media.Artwork_Preview);
  mame.Prog.Ini.WriteString('MEDIA', 'Bosses_Path', mame.Emu.Media.Bosses);
  mame.Prog.Ini.WriteString('MEDIA', 'Ends_Path', mame.Emu.Media.Ends);
  mame.Prog.Ini.WriteString('MEDIA', 'How_To_Path', mame.Emu.Media.How_To);
  mame.Prog.Ini.WriteString('MEDIA', 'Logos_Path', mame.Emu.Media.Logos);
  mame.Prog.Ini.WriteString('MEDIA', 'Scores_Path', mame.Emu.Media.Scores);
  mame.Prog.Ini.WriteString('MEDIA', 'Selects_Path', mame.Emu.Media.Selects);
  mame.Prog.Ini.WriteString('MEDIA', 'Stamps_Path', mame.Emu.Media.Stamps);
  mame.Prog.Ini.WriteString('MEDIA', 'Versus_Path', mame.Emu.Media.Versus);
  mame.Prog.Ini.WriteString('MEDIA', 'Warnings_Path', mame.Emu.Media.Warnings);
  mame.Prog.Ini.WriteString('MEDIA', 'Soundtracks_Path', mame.Emu.Media.Soundtracks);
  mame.Prog.Ini.WriteString('MEDIA', 'Support_Files_Path', mame.Emu.Media.Support_Files);
  mame.Prog.Ini.WriteString('MEDIA', 'Videos_Path', mame.Emu.Media.Videos);
end;

end.
