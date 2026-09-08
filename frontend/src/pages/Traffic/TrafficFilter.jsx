import { Select, Input, InputNumber, Space, Flex, Button } from "antd";
import { useEffect, useState } from "react";
import { getSupportedOpsByType, getOperandtCount, buildElasticQuery } from "@/utils/filter";
import { PlusOutlined } from "@ant-design/icons";

const RangeSetter = ({ number, onChange }) => {
  const [val1, setVal1] = useState(null);
  const [val2, setVal2] = useState(null);

  // fire a onChange event when either input changes
  useEffect(() => onChange([val1, val2]), [val1, val2]);

  return (
    <Space.Compact>
      {number
        ? <InputNumber style={{ width: '100px' }} placeholder="最小值" 
        onChange={val => setVal1(val)}
        />
        : <Input style={{ width: '100px', paddingLeft: '11px', paddingRight: '11px' }} size="small" placeholder="最小值" onChange={e => setVal1(e.target.value)} />
      }
      <Input
        size="small"
        style={{
          width: '30px',
          textAlign: 'center',
          borderLeft: 0,
          borderRight: 0,
          pointerEvents: 'none',
        }}
        placeholder="~"
        disabled
      />
      {number
        ? <InputNumber style={{ width: '100px' }} placeholder="最大值" onChange={val => setVal2(val)} />
        : <Input style={{ width: '100px', paddingLeft: '11px', paddingRight: '11px' }} size="small" placeholder="最大值" onChange={e => setVal2(e.target.value)} />
      }
    </Space.Compact>
  );
};

// elements of fieldList should be in the form of 
// { value: 'status', label: 'status', type: 'text' }
const TrafficFilter = ({ fieldList, handleSearch }) => {
  const [conditions, setConditions] = useState([]);
  const [logic, setLogic] = useState('and');

  const updateCondition = (index, newValues) => {
    const newConditions = [...conditions];
    newConditions[index] = { ...newConditions[index], ...newValues };
    setConditions(newConditions);
  };

  const addCondition = () => {
    setConditions([...conditions, { field: null, type: null, op: null, value: null }]);
  };

  const removeCondition = (index) => {
    const newConditions = [...conditions];
    newConditions.splice(index, 1);
    setConditions(newConditions);
  };

  const handleFieldChange = (index, fieldValue) => {
    const fieldDef = fieldList.find(f => f.value === fieldValue);
    updateCondition(index, {
      field: fieldValue,
      type: fieldDef?.type,
      op: null,
      value: null
    });
  };

  const handleGenerateQuery = () => {
    const query = buildElasticQuery(conditions, logic);
    handleSearch(query.query);
  };

  return (
    <>
      {conditions.length > 0 && (<Flex align="center" gap="large">
        <Select
          defaultValue="and"
          options={[
            { value: 'and', label: '与' },
            { value: 'or', label: '或' }
          ]}
          onChange={val => setLogic(val)}
        />

        <Flex vertical gap="middle">
          {conditions.map((cond, index) => {
            const ops = getSupportedOpsByType(cond.type);
            const operandCnt = getOperandtCount(cond.op);

            return (
              <Space block>
                <Select
                  showSearch
                  placeholder="选择字段"
                  style={{ width: 280 }}
                  value={cond.field}
                  options={fieldList}
                  onChange={val => handleFieldChange(index, val)}
                />

                <Space.Compact block>
                  <Select
                    placeholder="选择操作"
                    style={{ width: 140 }}
                    value={cond.op}
                    onChange={val => updateCondition(index, { op: val })}
                    disabled={!cond.type}
                  >
                    {ops.map(op => (
                      <Select.Option key={op} value={op}>
                        {op}
                      </Select.Option>
                    ))}
                  </Select>

                  {operandCnt > 0 && (
                    operandCnt === 1
                      ? <Input
                        size="small"
                        style={{ width: '228px' }}
                        onChange={(e) => updateCondition(index, { value: e.target.value })} 
                        />
                      : <RangeSetter 
                      number={cond.type === 'long'}
                      onChange={val => updateCondition(index, {value: val})}
                      />
                  )}
                </Space.Compact>

                <Button type="dashed" onClick={() => removeCondition(index)} danger>移除</Button>
              </Space>
            );
          })}
        </Flex>
      </Flex>
      )}
      <Space size="large" style={{ marginTop: '20px' }}>
        <Button shape="round" onClick={addCondition} icon={<PlusOutlined />}>
          添加条件
        </Button>
        <Button type="primary" onClick={handleGenerateQuery}>
          生成查询
        </Button>
      </Space>
    </>
  );
};

export default TrafficFilter;