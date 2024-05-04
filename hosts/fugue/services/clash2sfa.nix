{
  virtualisation.oci-containers.containers.clash2sfa = {
    image = "ghcr.io/xmdhs/clash2sfa:v0.13.1";
    ports = ["127.0.0.1:8080:5149"];
    volumes = [
      "clash2sfa:/server/db"
    ];
  };
}
