{ stdenv
, lib
, path
, callPackage
, fetchurl
, commandLineArgs ? ""
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "00x53h7pdb4l8fabv54jd9qgcklqxwc1pdmf8qi0y6cxvvxpil6r";
    x86_64-darwin = "1hjpvw67j8yhs1ngd91pyfcfpqkzkzdilvijxd7xwpja1g3zirl9";
    aarch64-linux = "14wda9p89m5yrh4vqli4gj9s9qhnrc72iys8xa8p5qqphs2dfjq1";
    aarch64-darwin = "104pz5vx1i7f94xx7apv1aw4n650qxix2s5sikdsq6j4g7yz1ik8";
    armv7l-linux = "0x6x3n55sy2kj4f064xwkfya526i80s3rypcbr8ncxzyiwl0f0j5";
  }.${system} or throwSystem;
in

callPackage "${path}/pkgs/applications/editors/vscode/generic.nix" rec {
  version = "1.81.0-insider";
  pname = "vscode-insiders";
  updateScript = ./update-vscode-insiders.sh;

  executableName = "code-insiders";
  longName = "Visual Studio Code - Insiders";
  shortName = "Code - Insiders";
  inherit commandLineArgs;

  src = fetchurl {
    name = "VSCode_${version}_${plat}.${archive_fmt}";
    url = "https://update.code.visualstudio.com/${version}/${plat}/insider";
    inherit sha256;
  };
  sourceRoot = "";

  meta = with lib; {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://code.visualstudio.com/";
    downloadPage = "https://code.visualstudio.com/Updates";
    license = licenses.unfree;
    # !!!: The insiders version breaks frequently, about once every month.
    #      You will get errors such as segfaults, crashes, issues related to
    #      read-only system, etc. For these reasons, I have personally switched
    #      to stable. Please use this package with caution.
    broken = true;
    mainProgram = "code-insiders";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
      "armv7l-linux"
    ];
  };
}
