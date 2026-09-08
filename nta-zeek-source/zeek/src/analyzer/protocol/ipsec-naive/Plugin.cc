#include "zeek/plugin/Plugin.h"
#include "zeek/analyzer/Component.h"
#include "zeek/analyzer/protocol/ipsec-naive/IPSecNaive.h"

namespace zeek::plugin::detail::Zeek_IPSecNaive {

class Plugin : public zeek::plugin::Plugin {
public:
	zeek::plugin::Configuration Configure() override
		{
		AddComponent(new zeek::analyzer::Component("IPSecNaive", zeek::analyzer::ipsec_naive::IPSecNaive_Analyzer::Instantiate));

		zeek::plugin::Configuration config;
		config.name = "Zeek::IPSecNaive";
		config.description = "A Naive analyzer for IPSec ESP/AH Protocol (which only parses them as connection)";
		return config;
		}
} plugin;

} // namespace zeek::plugin::detail::Zeek_IPSecNaive
