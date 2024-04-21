resource "aws_efs_file_system" "efs_volume" {
  creation_token = "efs-volume"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = true

  tags = {
    Name = "efs-volume"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_efs_mount_target" "mount_target_1" {
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.private1.id
  security_groups = [aws_security_group.app_server_sg.id]

}

resource "aws_efs_mount_target" "mount_target_2" {
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.private2.id
  security_groups = [aws_security_group.app_server_sg.id]


}

resource "aws_efs_mount_target" "mount_target_3" {
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.private3.id
  security_groups = [aws_security_group.app_server_sg.id]

  
}

resource "aws_efs_mount_target_attachment" "mount_target_attachment_1a" {
  mount_target_id = aws_efs_mount_target.mount_target_1.id
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.private1.id
}

resource "aws_efs_mount_target_attachment" "mount_target_attachment_1b" {
  mount_target_id = aws_efs_mount_target.mount_target_2.id
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.private2.id
}

resource "aws_efs_mount_target_attachment" "mount_target_attachment_1c" {
  mount_target_id = aws_efs_mount_target.mount_target_3.id
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.private3.id
}
