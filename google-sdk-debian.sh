#!/bin/sh

SDK_DIR=/usr/local/lib
apt update && apk install curl jq python3 || true
curl "https://www.googleapis.com/storage/v1/b/cloud-sdk-release/o?prefix=google-cloud-sdk-4" \
  | jq -r '.items[].selfLink | select ( match ("linux-x86_64") )' \
  | tail -n1 \
  | curl -s $(awk '{print $1"?alt=media"}') | tar xzf - -C $SDK_DIR
/usr/local/lib/google-cloud-sdk/install.sh --quiet
echo "export PATH=$SDK_DIR/google-cloud-sdk/bin:$PATH" | tee -a /etc/profile.d/gcloud-sdk.sh
. /etc/profile

ln -s $SDK_DIR/google-cloud-sdk/bin/gcloud /usr/bin/gcloud
ln -s $SDK_DIR/google-cloud-sdk/bin/gsutil /usr/bin/gsutil

#test gcloud cli
gcloud version
