// Output the ID of the EC2 instance created
output "bastion_instance_id" {
  value = "${aws_instance.bastion_instance.id}"
}

output "bastion_eip" {
  value = "${aws_eip.bastion_eip.public_ip}"
}