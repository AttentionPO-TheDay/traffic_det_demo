// See the file "COPYING" in the main distribution directory for copyright.

#include "zeek/zeek-config.h"
#include "zeek/analyzer/protocol/ipsec-naive/IPSecNaive.h"

#include <algorithm>

#include "zeek/IP.h"
#include "zeek/RunState.h"
#include "zeek/NetVar.h"
#include "zeek/Event.h"
#include "zeek/Conn.h"
#include "zeek/Desc.h"
#include "zeek/Reporter.h"

#include "analyzer/protocol/ipsec-naive/events.bif.h"

namespace zeek::analyzer::ipsec_naive {

IPSecNaive_Analyzer::IPSecNaive_Analyzer(Connection* c)
    : TransportLayerAnalyzer("IPSecNaive", c)
{
    c->SetInactivityTimeout(zeek::detail::ipsec_naive_inactivity_timeout);
}

void IPSecNaive_Analyzer::Done()
{
    TransportLayerAnalyzer::Done();
}

void IPSecNaive_Analyzer::DeliverPacket(int len, const u_char* data,
            bool is_orig, uint64_t seq, const IP_Hdr* ip, int caplen)
{
    assert(ip);
    TransportLayerAnalyzer::DeliverPacket(len, data, is_orig, seq, ip, caplen);

    int proto = ip->NextProto();
    if (proto == IPPROTO_AH) {
        zeek::BifEvent::enqueue_ah_message_over_ip(this, Conn(), is_orig, len);
    } else {
        zeek::BifEvent::enqueue_esp_message_over_ip(this, Conn(), is_orig, len);
    }

    Conn()->SetLastTime(run_state::current_timestamp);
}


bool IPSecNaive_Analyzer::IsReuse(double /* t */, const u_char* /* pkt */)
{
    return false;
}

unsigned int IPSecNaive_Analyzer::MemoryAllocation() const
{
    return Analyzer::MemoryAllocation()
        + padded_sizeof(*this) - padded_sizeof(Connection);
}



} // namespace zeek::analyzer::ipsec_naive
