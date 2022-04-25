{ ... }: {
  programs.gnupg = {
    agent.enable = true;
    agent.pinentryFlavor = "qt";
  };
}
