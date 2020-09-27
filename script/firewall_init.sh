#!/bin/bash
### chain policy can be:NEXT ACCEPT DROP

#### filter  FORWARD ######
filter_forward=(
'
chain_lan_mac
    zone_lan_mac
    policy_lan_mac/NEXT
'
'
chain_lan_ip
    zone_lan_ip
    policy_lan_ip/NEXT
'
'
chain_portal
    zone_portal
    policy_portal/NEXT
'
'
chain_specialapp
    zone_specialapp
    policy_specialapp/NEXT
'
'
chain_mqtt
    zone_mqtt
    policy_mqtt/NEXT
'
)

##### filter  INPUT #######
filter_input=(
'
chain_wanping
    zone_wanping
    policy_wanping/NEXT
'
'
chain_service_ctrl
    zone_service_ctrl
    policy_service_ctrl/NEXT
'
)

###### nat  PREROUTING ########
nat_prerouting=(
'
chain_portal
    zone_portal
    policy_portal/NEXT
'
'
chain_dmz
    zone_dmz
    policy_dmz/NEXT
'
'
chain_portmap
    zone_portmap
    policy_portmap/NEXT
'
'
chain_specialapp
    zone_specialapp
    policy_specialapp/NEXT
'
'
chain_domain
    zone_domain
    policy_domain/NEXT
'
)

make_chain()  #table chain array
{
iptables_table="$1"
iptables_chain="$2"
iptables_chain_l=`echo "${iptables_chain}" | tr '[A-Z]' '[a-z]'`
shift
shift

ENTRANCE_MAIN="chain_kthy_${iptables_chain_l}"
ENTRANCE_MAIN_POLICY="policy_kthy_${iptables_chain_l}"
iptables -t ${iptables_table} -N ${ENTRANCE_MAIN}
iptables -t ${iptables_table} -N ${ENTRANCE_MAIN_POLICY}
iptables -t ${iptables_table} -A ${ENTRANCE_MAIN_POLICY} -j ACCEPT
for chain in "$@"
do 
    VAL_CHAIN=""
    VAL_ZONE=""
    VAL_POLICY=""
    VAL_TARGET=""
    for child_chain in ${chain}
    do
        if [[ "${child_chain}" =~ "chain_" ]]; then
            VAL_CHAIN="${child_chain}"
        fi
        if [[ "${child_chain}" =~ "zone_" ]]; then
            VAL_ZONE="${child_chain}"
        fi
        if [[ "${child_chain}" =~ "policy_" ]]; then
            VAL_POLICY=`echo "${child_chain}" |cut -d "/" -f1`
            VAL_TARGET=`echo "${child_chain}" |cut -d "/" -f2`
        fi
    done
    iptables -t ${iptables_table} -N ${VAL_CHAIN} 
    iptables -t ${iptables_table} -N ${VAL_ZONE} 
    iptables -t ${iptables_table} -N ${VAL_POLICY} 
    iptables -t ${iptables_table} -A ${VAL_CHAIN} -j ${VAL_ZONE}
    iptables -t ${iptables_table} -A ${VAL_CHAIN} -j ${VAL_POLICY}
    
    if [ -n "${NEXT_BACKUP}" ]; then
        iptables -t ${iptables_table} -A ${NEXT_BACKUP} -j ${VAL_CHAIN}
    fi
    if [ "${VAL_TARGET}" == "NEXT" ]; then
        NEXT_BACKUP="${VAL_POLICY}"	
    else
        NEXT_BACKUP=""
        iptables -t ${iptables_table} -A ${VAL_POLICY} -j ${VAL_TARGET}
    fi
    iptables -t ${iptables_table} -A ${ENTRANCE_MAIN} -j ${VAL_CHAIN}
done

if [ -n "${NEXT_BACKUP}" ]; then
    iptables -t ${iptables_table} -A ${NEXT_BACKUP} -j ${ENTRANCE_MAIN_POLICY}
    NEXT_BACKUP=""
fi
iptables -t ${iptables_table} -A ${iptables_chain} -j ${ENTRANCE_MAIN}
}

iptables -t filter -F
iptables -t nat -F
iptables -t mangle -F
make_chain filter FORWARD "${filter_forward[@]}"
make_chain filter INPUT "${filter_input[@]}"
make_chain nat PREROUTING "${nat_prerouting[@]}"
exit 0
