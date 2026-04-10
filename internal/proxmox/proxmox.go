package proxmox

import (
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

type Controller struct {
	image  string
	sshkey string
}

func New(image, sshkey string) *Controller {
	return &Controller{
		image:  image,
		sshkey: sshkey,
	}
}

func (c *Controller) DeployInstance(ctx pulumi.Context) error {

}
