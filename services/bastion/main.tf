
resource "aws_eip" "bastion_eip" {
  vpc = true

  lifecycle {  prevent_destroy = false }
}


resource "aws_eip_association" "bastion_instance" {
  instance_id = "${aws_instance.bastion_instance.id}"
  allocation_id = "${aws_eip.bastion_eip.id}"
}

resource "aws_instance" "bastion_instance" {
    ami = "${var.ami_id}"
    subnet_id = "${var.subnet_id}"
    key_name = "${var.key_name}"
    instance_type = "${var.instance_type}"

    tags = "${merge(var.tags, 
              map("Name", var.instance_name))}"

    disable_api_termination = "${var.disable_api_termination}"

    root_block_device {

       delete_on_termination = "${var.delete_on_termination}"

    }

    vpc_security_group_ids = [ "${aws_security_group.bastion_sg.id}" ]
}


data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}

data "aws_vpc" "selected" {
  id = "${data.aws_subnet.selected.vpc_id}"
}


resource "aws_security_group" "bastion_sg" {
  name = "${format("%s-sg", var.instance_name)}"
  description = "-"
  vpc_id = "${data.aws_subnet.selected.vpc_id}"
  
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]    
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, 
            map("Name", format("%s-sg", var.instance_name))) }"     

}
