// See the file "COPYING" in the main distribution directory for copyright.

#pragma once

#include "zeek/RuleMatcher.h"
#include "zeek/analyzer/Analyzer.h"
#include "zeek/net_util.h"

ZEEK_FORWARD_DECLARE_NAMESPACED(VectorVal, zeek);
namespace zeek {
using VectorValPtr = IntrusivePtr<VectorVal>;
}

namespace zeek::analyzer::ipsec_naive {

// 对 AH 和 ESP 协议做裸的解析（直接解析为一条流，但不提取任何元数据）。
class IPSecNaive_Analyzer final : public analyzer::TransportLayerAnalyzer {
public:
	explicit IPSecNaive_Analyzer(Connection* conn);

	static analyzer::Analyzer* Instantiate(Connection* conn)
		{ return new IPSecNaive_Analyzer(conn); }

protected:
	void Done() override;
	void DeliverPacket(int len, const u_char* data, bool orig,
	                   uint64_t seq, const IP_Hdr* ip, int caplen) override;
	bool IsReuse(double t, const u_char* pkt) override;
	unsigned int MemoryAllocation() const override;

private:
	void UpdateEndpointVal(const ValPtr& endp, bool is_orig);
};

} // namespace zeek::analyzer::ipsec_naive
