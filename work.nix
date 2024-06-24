{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    kubelogin
    kustomize
    k9s
    newman
    postman
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    vault
    jira-cli-go
  ];
}
