#! /bin/bash

# Initialization
gcloud init < a

ID=$(gcloud info --format='value(config.project)')

# Creating a custom role
if  gcloud iam roles create editor --project $ID \
        --file role-definition.yaml
then
  printf "\n\e[1m%s\n\n\e[m" 'Editor Role Created: Checkpoint Completed (1/6)'
  sleep 2

  if  gcloud iam roles create viewer --project $ID \
          --title "Role Viewer" \
          --description "Custom role description." \
          --permissions compute.instances.get,compute.instances.list \
          --stage ALPHA
  then
    printf "\n\e[1m%s\n\n\e[m" 'Viewer Role Created: Checkpoint Completed (2/6)'
    sleep 2

    # Editing an existing custom role
    if  gcloud iam roles update editor --project $ID \
            --add-permissions storage.buckets.get,storage.buckets.list
    then
      printf "\n\e[1m%s\n\n\e[m" 'Editor Role Updated: Checkpoint Completed (3/6)'
      sleep 2
    
      if  gcloud iam roles update viewer --project $ID \
              --add-permissions storage.buckets.get,storage.buckets.list
      then
        printf "\n\e[1m%s\n\n\e[m" 'Viewer Role Updated: Checkpoint Completed (4/6)'
        sleep 2

        # Disabling a custom role
        if  gcloud iam roles update viewer --project $ID \
                --stage DISABLED
        then
          printf "\n\e[1m%s\n\n\e[m" 'Role Disabled: Checkpoint Completed (5/6)'
          sleep 2
        
          # Deleting & Undeleting a custom role
          if (gcloud iam roles delete viewer --project $ID
              gcloud iam roles undelete viewer --project $ID)
          then
            printf "\n\e[1m%s\n\n\e[m" 'Role Undeleted: Checkpoint Completed (6/6)'
            sleep 2.5

            printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
          fi
        fi
      fi
    fi
  fi
fi

gcloud auth revoke --all