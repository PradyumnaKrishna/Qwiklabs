#! /bin/sh

###################################################################################################################
#                                                   MIT License                                                   # 
#                                                                                                                 #
# Copyright (c) 2020 Pradyumna Krishna | Abhinandan Arya                                                          #
#                                                                                                                 #
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated    #
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation #
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,    #
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:          #
#                                                                                                                 #
# The above copyright notice and this permission notice shall be included in all copies or substantial portions   #
# of the Software.                                                                                                #
#                                                                                                                 #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED   #
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   #
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF   #
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        #
# DEALINGS IN THE SOFTWARE.                                                                                       #
###################################################################################################################

# Initializes the Configuration
gcloud init < a
gcloud config set spanner/instance test-instance

# Create an Instance and Database
if (gcloud spanner instances create test-instance \
      --config=regional-us-central1 --description="My Instance" --nodes=1
    gcloud spanner databases create example-db)
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Instance & Database Created: Checkpoint Completed (1/2)'
  sleep 2.5

  # Create a schema for your database
  if gcloud spanner databases ddl update example-db \
       --ddl='CREATE TABLE Singers (
         SingerId   INT64 NOT NULL,
         FirstName  STRING(1024),
         LastName   STRING(1024),
         SingerInfo BYTES(MAX),
         BirthDate  DATE,
         )PRIMARY KEY(SingerId);'
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Database Schema Created: Checkpoint Completed (2/2)'
    sleep 2.5

    printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
  fi
fi
gcloud auth revoke --all