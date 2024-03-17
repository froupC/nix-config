rec {
  # user information
  username = "froup";
  fullUsername = "Froup See";
  userEmail = "froupC@outlook.com";

  allSystemsAttrset = {
    x64-linux = "x86_64-linux";
    x64-arm = "aarch64-linux";
  };

  allSystems = builtins.attrValues allSystemsAttrset;
}
