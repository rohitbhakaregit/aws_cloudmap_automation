
resource "aws_appmesh_mesh" "apps-auto" {
  name = "apps-auto"

  spec {
    egress_filter {
      type = "ALLOW_ALL"
    }
  }
}

#virtual node to access cloud map 


resource "aws_appmesh_virtual_node" "servicea" {
  name      = "serviceA"
  mesh_name = aws_appmesh_mesh.apps-auto.name

  spec {
    backend {
      virtual_service {
        virtual_service_name = "serviceb.apps-auto.local"
      }
    }

    listener {
      port_mapping {
        port     = 8080
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        service_name   = "pingpong"
        namespace_name = "apps.local"
      }
    }
  }
}


# create virtual service 

resource "aws_appmesh_virtual_service" "servicea" {
  name      = "servicea.apps-auto.local"
  mesh_name = aws_appmesh_mesh.apps-auto.name

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.servicea.name
      }
    }
  }
}
