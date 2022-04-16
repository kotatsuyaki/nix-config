{ pkgs, ... }: {
  # Larger tty font
  console.font = "ter-132n";
  console.packages = with pkgs; [
    terminus
  ];
}
