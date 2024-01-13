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

- [x] Após rodar terraform apply
Podemos observar abaixo o deploy feito com Terraform.

<p>
<img src="screenshots/apply_erro_1.png" height="800" width="600" >
</p>



- [x] Acessar instancia
Iremos acessar via ssh com ip Azure Firewall onde esta realizando DNAT para spoke1.

- [x] R
Rodar
gcloud init

gcloud auth application-default login

git clone https://github.com/geantrevisan/gcp-gke.git

cd gcp-gke/terraform/
terraform init


terraform plan -var="region=us-central1" -var="project=project-monks" -var="container_image=gean22/appimage:latest"

terraform apply -var="region=us-central1" -var="project=project-monks" -var="container_image=gean22/appimage:latest"
<p>
<img src="screenshots/apply_na_maquina.png" height="800" width="600" >
</p>

Segundo
<p>
<img src="screenshots/apply_sucesso.png" height="800" width="600" >
</p>

Para acessar o app
https://monks.tigkf.tech/

<p>
<img src="screenshots/monks.png" height="800" width="600" >
</p>

### FIM

<p>
<img src="screenshots/cargas_de_trabalho.png" height="800" width="600" >
</p>

<p>
<img src="screenshots/nginx_ingress.png" height="800" width="600" >
</p>

<p>
<img src="screenshots/app_deploy.png" height="800" width="600" >
</p>

# Terraform
Criei todo codigo do terraforma com comentarios nos .tf. creio que ficou claro para entendimento.

# Links de referencias.

[Criar IAM para repo github](https://medium.com/@irem.ertuerk/iac-with-github-actions-for-google-cloud-platform-bc28f1c4b0c7)
[Terraform node](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool.html)
[Terraform script instancia](https://fabianlee.org/2021/05/28/terraform-invoking-a-startup-script-for-a-gce-google_compute_instance/)
[Terraform instancia](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)
[Terraform modules](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
[Terraform provider](https://registry.terraform.io/providers/Twingate/twingate/latest/docs/guides/gke-helm-provider-deployment-guide)
[Terraform vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)
[Terraform subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork)
[Terraform GKE](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster)
[Terraform anddress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address.html)
[Terraform nat/firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat)
[Terraform nat route](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat)
[Terraform nat gateway](https://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/1.4.0?utm_content=documentLink&utm_medium=Visual+Studio+Code&utm_source=terraform-ls)