import numpy as np
from elasticsearch import Elasticsearch
from flask import Flask, request
import json
import nmap
import sys

from nistrng import pack_sequence, check_eligibility_all_battery, SP800_22R1A_BATTERY, run_all_battery

if len(sys.argv) != 2:
    print(f'参数不合法。命令行参数：{sys.argv[0]} <ES 服务器地址>\n')
    exit(1)

ELASTIC_HOST = sys.argv[1]

app = Flask(__name__)
app.config.from_object(__name__)

Status = "Stop"


def ip_to_num(ip):
    n = [int(x) for x in ip.split('.')]

    return n[0] * 16777216 + n[1] * 65536 + n[2] * 256 + n[3]


def num_to_ip(num):
    s = []
    while num > 0:
        s.append(str(num % 256))
        num //= 256

    return ".".join(reversed(s))


def getDataFrameImpl(id):
    query = {
        "query": {
            "term": {
                # "ip.length": {
                #     "value": 432,
                #     "boost": 1.0
                # }
                '_id': id
                # 'hash': '9067121692c08c010fb615ec3eccc9cf'
            }
        }
    }

    es = Elasticsearch([{'host': ELASTIC_HOST, 'port': 9200}], timeout=3600)
    result1 = es.search(index="test-traffic", body=query)
    # result = es.search(index="test-traffic")
    # print(result)
    # print(result1)
    hits_out = result1["hits"]
    hits_inner = hits_out["hits"]
    print(hits_inner)
    soucre_0 = hits_inner[0]
    source = soucre_0["_source"]
    print(source)

    # tcp = source['tcp']
    # payload = tcp['payload']
    x = []
    y = []

    ip = source['ip']
    payload = ip['payload']

    y.append('ip-src')
    y.append('ip-dst')
    y.append('ip-protocol')
    y.append('ip-version')
    y.append('ip-length')
    if 'src' in ip:
        x.append(ip['src'])
    else:
        x.append('-1.-1.-1.-1')
    if 'dst' in ip:
        x.append(ip['dst'])
    else:
        x.append('-1.-1.-1.-1')
    if 'protocol' in ip:
        x.append(ip['protocol'])
    else:
        x.append(-1)
    if 'version' in ip:
        x.append(ip['version'])
    else:
        x.append(-1)
    if 'length' in ip:
        x.append(ip['length'])
    else:
        x.append(-1)

    y.append('tcp-client_port')
    y.append('tcp-server_port')
    y.append('tcp-packet_up')
    y.append('tcp-byte_up')
    y.append('tcp-packet_dn')
    y.append('tcp-byte_dn')
    y.append('tcp-packet_retrans_up')
    y.append('tcp-byte_retrans_up')
    y.append('tcp-packet_retrans_dn')
    y.append('tcp-byte_retrans_dn')
    if 'tcp' in source:
        tcp = source['tcp']
        if 'client_port' in tcp:
            x.append(tcp['client_port'])
        else:
            x.append(-1)
        if 'server_port' in tcp:
            x.append(tcp['server_port'])
        else:
            x.append(-1)
        if 'packet_up' in tcp:
            x.append(tcp['packet_up'])
        else:
            x.append(-1)
        if 'packet_dn' in tcp:
            x.append(tcp['packet_dn'])
        else:
            x.append(-1)
        if 'byte_up' in tcp:
            x.append(tcp['byte_up'])
        else:
            x.append(-1)
        if 'byte_dn' in tcp:
            x.append(tcp['byte_dn'])
        else:
            x.append(-1)
        if 'packet_retrans_up' in tcp:
            x.append(tcp['packet_retrans_up'])
        else:
            x.append(-1)
        if 'byte_retrans_up' in tcp:
            x.append(tcp['byte_retrans_up'])
        else:
            x.append(-1)
        if 'packet_retrans_dn' in tcp:
            x.append(tcp['packet_retrans_dn'])
        else:
            x.append(-1)
        if 'byte_retrans_dn' in tcp:
            x.append(tcp['byte_retrans_dn'])
        else:
            x.append(-1)
    else:
        for i in range(10):
            x.append(-1)

    y.append('udp-src')
    y.append('udp-dst')
    y.append('udp-packet_up')
    y.append('udp-packet_dn')
    y.append('udp-byte_up')
    y.append('udp-byte_dn')
    if 'udp' in source:
        udp = source['udp']
        if 'src' in udp:
            x.append(source['src'])
        else:
            x.append(-1)
        if 'dst' in udp:
            x.append(source['dst'])
        else:
            x.append(-1)
        if 'packet_up' in udp:
            x.append(source['packet_up'])
        else:
            x.append(-1)
        if 'packet_dn' in udp:
            x.append(source['packet_dn'])
        else:
            x.append(-1)
        if 'byte_up' in udp:
            x.append(source['byte_up'])
        else:
            x.append(-1)
        if 'byte_dn' in udp:
            x.append(source['byte_dn'])
        else:
            x.append(-1)
    else:
        for i in range(6):
            x.append(-1)

    y.append('dns-query')
    y.append('dns-qtype')
    y.append('dns-qclass')
    y.append('dns-answers')
    if 'dns' in source:
        dns = source['dns']
        if 'queries' in dns:
            query = dns['queries'][0]
            x.append(query['query'])
            x.append(query['qtype'])
            x.append(repr(query['qclass']))
            x.append(query['answers'])
    else:
        for i in range(4):
            x.append(-1)

    y.append('http-method')
    y.append('http-uri')
    y.append('http-version')
    y.append('http-content_type')
    y.append('http-status')
    y.append('http-src_headers')
    y.append('http-dst_headers')
    if 'http' in source:
        http = source['http']
        if 'method' in http:
            x.append(http['method'])
        else:
            x.append(-1)
        if 'uri' in http:
            x.append(http['uri'])
        else:
            x.append(-1)
        if 'version' in http:
            x.append(http['version'])
        else:
            x.append(-1)
        if 'content_type' in http:
            x.append(http['content_type'])
        else:
            x.append(-1)
        if 'status' in http:
            x.append(repr(http['status']))
        else:
            x.append(-1)
        if 'src_headers' in http:
            x.append(repr(http['src_headers']))
        else:
            x.append(-1)
        if 'dst_headers' in http:
            x.append(repr(http['dst_headers']))
        else:
            x.append(-1)
    else:
        for i in range(7):
            x.append(-1)

    y.append('ssl-src_hello')
    y.append('ssl-dst_hello')
    y.append('ssl-src_version')
    y.append('ssl-src_record_version')
    y.append('ssl-src_hello_random')
    y.append('ssl-src_hello_session_id')
    y.append('ssl-dst_version')
    y.append('ssl-dst_record_version')
    y.append('ssl-dst_hello_random')
    y.append('ssl-dst_hello_session_id')
    y.append('ssl-dst_cipher')
    if 'ssl' in source:
        ssl = source['ssl']
        if 'src_hello' in ssl:
            x.append(ssl['src_hello'])
        else:
            x.append(-1)
        if 'dst_hello' in ssl:
            x.append(ssl['dst_hello'])
        else:
            x.append(-1)
        if 'src_version' in ssl:
            x.append(ssl['src_version'])
        else:
            x.append(-1)
        if 'src_record_version' in ssl:
            x.append(ssl['src_record_version'])
        else:
            x.append(-1)
        if 'src_hello_random' in ssl:
            x.append(ssl['src_hello_random'])
        else:
            x.append(-1)
        if 'src_hello_session_id' in ssl:
            x.append(ssl['src_hello_session_id'])
        else:
            x.append(-1)
        if 'dst_version' in ssl:
            x.append(ssl['dst_version'])
        else:
            x.append(-1)
        if 'dst_record_version' in ssl:
            x.append(ssl['dst_record_version'])
        else:
            x.append(-1)
        if 'dst_hello_random' in ssl:
            x.append(ssl['dst_hello_random'])
        else:
            x.append(-1)
        if 'dst_hello_session_id' in ssl:
            x.append(ssl['dst_hello_session_id'])
        else:
            x.append(-1)
        if 'dst_cipher' in ssl:
            x.append(repr(ssl['dst_cipher']))
        else:
            x.append(-1)
    else:
        for i in range(11):
            x.append(-1)

    for i in range(350):
        y_tmp = 'payload-' + str(i + 1)
        y.append(y_tmp + '-' + 'timestamp')
        y.append(y_tmp + '-' + 'length')
        y.append(y_tmp + '-' + 'is_orig')
        if i < len(payload):
            x_tmp = payload[i]
            x.append(x_tmp['timestamp'])
            x.append(x_tmp['length'])
            x.append(x_tmp['is_orig'])
        else:
            x.append(-1)
            x.append(-1)
            x.append(-1)

    print(x)
    print(y)
    print(len(x), len(y))

    from pyspark.sql import SparkSession

    spark = SparkSession.builder.getOrCreate()

    rdd = spark.sparkContext.parallelize([x])
    df = spark.createDataFrame(rdd, schema=y)
    df.show()

    filename = id + '.csv'
    df.write.csv(filename, header=True)


@app.route('/', methods=['POST'])
def index():
    global Status
    Status = "Running"
    data = request.get_data()
    if data is None or len(data) == 0:
        return json.dumps({'msg': '输入为0，请检查输入'})
    data = data.decode()
    data = json.loads(data)
    if len(data) != 2:
        return json.dumps({'msg': '输入非法，请检查输入'})
    res = {'msg': 'success'}
    start = data['start']
    end = data['end']
    start_num, end_num = ip_to_num(start), ip_to_num(end)
    ip = start_num
    nm = nmap.PortScanner()
    tmp = []
    while Status == "Running" and ip <= end_num:
        state = "unknown"
        os = 'unknown'
        # print(num_to_ip(ip))
        try:
            nm.scan(num_to_ip(ip), arguments='-O -n -PE', timeout=60)
            for host in nm.all_hosts():
                state = nm[host].state()
                os = nm[host].get('osmatch')[0].get('name')
            tmp.append({'ip': num_to_ip(ip), 'status': state, 'os': os})
        except:
            tmp.append({'ip': num_to_ip(ip), 'status': 'down', 'os': ''})
        ip += 1
    # print(tmp)
    res['ans'] = tmp
    Status = "Stop"
    return res
    # return json.dumps(res)


@app.route('/stop', methods=['POST'])
def stop():
    global Status
    Status = "Stop"
    res = {'success': True, 'status': Status, 'msg': ''}
    return res


@app.route('/status', methods=['GET'])
def getstatus():
    res = {'success': True, 'status': Status, 'msg': ''}
    return res


@app.route('/dataFrame', methods=['POST'])
def getDataFrame():
    try:
        data = request.get_data()
        data = data.decode()
        data = json.loads(data)
        id = data['id']
        getDataFrameImpl(id)
        res = {'success': True, 'msg': ''}
    except Exception as e:
        res = {'success': False, 'msg': str(e)}

    return res


@app.route('/randomTest', methods=['POST'])
def randomTest():
    data = request.get_data()
    data = data.decode()
    data = json.loads(data)
    data = data['data']
    random = np.array(data, dtype=np.long)
    binary_sequence = pack_sequence(random)
    eligible_battery: dict = check_eligibility_all_battery(binary_sequence, SP800_22R1A_BATTERY)
    results = run_all_battery(binary_sequence, eligible_battery, False)
    res_all = []
    res = {}
    for result, elapsed_time in results:
        tmp = {}
        tmp['testName'] = result.name
        tmp['probability'] = result.score
        tmp['passed'] = result.passed
        res_all.append(tmp)
    res['resList'] = res_all
    return res


@app.route('/verify-cert', methods=['POST'])
def verify_cert():
    data = request.get_json(force=True)
    print(data)
    return {
        'result': 20,
        'result_msg': '国密证书'
    }


if __name__ == '__main__':
    app.run(debug=True, threaded=True, host='0.0.0.0', port=8888)

# 连接ES
# es = Elasticsearch([{'host':'10.101.12.19','port':9200}], timeout=3600)

# 'CWRKal2hYy19yCh7C6'


# getDataFrame('CWRKal2hYy19yCh7C6')
