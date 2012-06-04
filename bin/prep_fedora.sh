#!/usr/bin/env bash

# Oracle needs the hostname and ip to be on /etc/hosts
if ! grep -q $(hostname) /etc/hosts; then
  echo "Full hostname not found in /etc/hosts file, adding it."
  IP=$(ip addr show eth0 | sed -n 's/.*inet \(.*\)\/.*/\1/p')
  echo "$IP $(hostname) $(hostname -s)"
fi

# kernel parameters
KPARAMS=$(sysctl -N -p 2> /dev/null)
while read param; do
  name=$(echo -n ${param} | cut -d'=' -f1 )
  if [[ "${name}" =~ "${KPARAMS}" ]]; then
    echo "Found conflicting param ${name}"
  else
    echo "Adding ${param} to sysctl.d/oracle.conf"
    echo "${param} >> /etc/sysctl.d/oracle.conf"
  fi
done < kernel_params


