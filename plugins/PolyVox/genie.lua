function pluginBuildScript(_name)
    project (_name)
        location (path.join(BUILD_DIR, "plugins"))
        targetdir (path.join(PLUGIN_BUILD_DIR, _name) .. "/1/")

        targetname (_name)
        language "C++"
        kind "SharedLib"

        flags {
            "No64BitChecks",
            "ExtraWarnings",
            "StaticRuntime"
        }

        includedirs {
            SRC_DIR,
            path.join(LIB_DIR, "assimp/include"),
            path.join(LIB_DIR, "bgfx/include"),
            path.join(LIB_DIR, "bgfx/common"),
            path.join(LIB_DIR, "bgfx/common/imgui"),
            path.join(LIB_DIR, "bgfx/common/nanovg"),
            path.join(LIB_DIR, "openal/win32"),
            path.join(PLUGIN_DIR, _name .. "/PolyVoxCore/include"),
        }

        files {
            path.join(PLUGIN_DIR, _name .. "/**.h"),
            path.join(PLUGIN_DIR, _name .. "/**.cpp"),
            path.join(PLUGIN_DIR, _name .. "/**.cc"),
        }

        links {
            "Torque6"
        }
     
        defines {
            "TORQUE_PLUGIN",
            "_USRDLL"
        }

        configuration "Debug"
            defines     { "TORQUE_DEBUG", "TORQUE_ENABLE_PROFILER" }
            flags       { "Symbols" }

        configuration "Release"
            defines     { }
            flags       { }

        configuration "vs*"
            defines     { "_CRT_SECURE_NO_WARNINGS" }
            buildoptions    { "/wd4100", "/wd4800" }

        configuration "vs2015"
            windowstargetplatformversion "10.0.10240.0"

        configuration "windows"
            links { "ole32" }
            defines { "WIN32", "_WINDOWS" }

        configuration "linux"
            links       { "dl" }

        configuration "bsd"

        configuration "linux or bsd"
            defines     {  }
            links       { "m" }
            linkoptions { "-rdynamic" }

        configuration "macosx"
            defines     {  }
            links       { "CoreServices.framework" }

        configuration { "macosx", "gmake" }
            buildoptions { "-mmacosx-version-min=10.4" }
            linkoptions  { "-mmacosx-version-min=10.4" }
end
