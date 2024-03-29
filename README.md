# Caso Azure Cloud - B3.
### O que usamos? :
- Azure Cloud
- Azure Firewall
- 2 Maquinas Spoke Linux
- Apache
- Terraform
- GitHub

<p>
<img src="https://cdn.dribbble.com/users/3847465/screenshots/10765125/azure.gif" height="36" width="36" >
<img src="https://code.benco.io/icon-collection/azure-docs/firewall.svg" height="36" width="36" >
<img src="https://w7.pngwing.com/pngs/130/892/png-transparent-apache-tomcat-apache-http-server-web-server-java-servlet-javaserver-pages-others-miscellaneous-text-logo-thumbnail.png" height="36" width="36" >
<img src="https://code.benco.io/icon-collection/azure-docs/logo_terraform.svg"  height="36" width="36" >
</p>

# Sobre caso
Utilizamos codigo terraform para codar toda arquitetura, abaixo está cada ingrediente utilizada.
* Criado 1 Vnet e subnet para Azure Firewall.
* Criado 2 Vnet e subnet para as maquinas spoke (uma spoke1-subnet /27 e spoke2-subnet /28).
* Criado 1 NSG para cada maquina spoke.
* Criado 1 DNAT via Azure Firewall apenas para instacia spoke1 onde possa fazer tunel a outras spoke2.
* Criado 1 NAT para a saida padrão internet via Azure Firewall nas instancias spokes.
* Criado 1 script para subir apache2 no spoke2
* Criado 1 DNAT porta 80 para spoke2.
* Deploy via terraform.

# Passo a Passo
- [x] Iniciar az cli.
```console
az login
```

- [x] Configurar ID SUB.
Ajustar na variables.tf a ID da sub para realizar o deploy no recurso desejado.

- [x] Terraform
```console
terraform init
```

- [x] Terraform
```console
terraform plan
```

- [x] Terraform
```console
terraform apply
```
<p>
<img src="screenshots/apply.png" height="450" width="600" >
</p>

- [x] Após rodar terraform apply
Podemos observar abaixo o deploy feito com Terraform.

<p>
<img src="screenshots/apply2.png" height="450" width="600" >
</p>

- [x] Acessar instancia
Iremos acessar via ssh com ip Azure Firewall onde esta realizando DNAT para spoke1.

<p>
<img src="screenshots/ssh-azure-firewall.png" height="450" width="600" >
</p>

- [x] Extra
Subi uma pagina customizada no spoke2, realizei DNAT para porta 80.
http://IP_VM_SPOKE2/

<p>
<img src="screenshots/http.png" height="450" width="600" >
</p>

# Terraform
Criei todo codigo do terraforma com comentarios nos .tf. creio que ficou claro para entendimento.

# Links de referencias.

[Terraform Computer e script](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension)
[Terraform Azure Firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall)
[Terraform provider](https://registry.terraform.io/providers/Twingate/twingate/latest/docs/guides/gke-helm-provider-deployment-guide)
[Terraform vnet e subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
[Terraform anddress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip)
[Terraform firewall rule collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection)
[Terraform firewall nat rule collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection)
[Terraform firewall network rule collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection)
[Terraform route table e association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association)
[Terraform nat gateway](https://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/1.4.0?utm_content=documentLink&utm_medium=Visual+Studio+Code&utm_source=terraform-ls)