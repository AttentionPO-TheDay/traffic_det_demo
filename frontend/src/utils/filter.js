export const Ops = Object.freeze({
  IS_TRUE: '为真',
  IS_FALSE: '为假',

  EQUAL: '为',
  NOT_EQUAL: '不为',
  GREATER: '大于',
  LESS: '小于',
  GREATER_OR_EQUAL: '大于等于',
  LESS_OR_EQUAL: '小于等于',

  BETWEEN: '处于范围',
  EXCEPT: '不处于范围',

  CONTAINS: '包含',
  NOT_CONTAINS: '不包含'
});

/**
 * 返回特定运算符需要的操作数数量
 * @param {string} op - 运算符（来自 Ops枚举）
 * @returns {string[]} 需要的操作数数量
 */
export function getOperandtCount(op) {
  if (!op || [Ops.IS_TURE, Ops.IS_FALSE].includes(op)) return 0;
  if ([Ops.GREATER, Ops.LESS, Ops.GREATER_OR_EQUAL, Ops.LESS_OR_EQUAL, Ops.EQUAL, Ops.NOT_EQUAL, Ops.CONTAINS, Ops.NOT_CONTAINS].includes(op)) return 1;
  if ([Ops.BETWEEN, Ops.EXCEPT].includes(op)) return 2;
}

/**
 * 返回指定类型支持的运算符列表
 * @param {string} type - 数据类型，支持: boolean, text, long, float
 * @returns {string[]} 对应的运算符（来自 Ops）
 */
export function getSupportedOpsByType(type) {
  if (!type) return [];

  switch (type.toLowerCase()) {
    case 'boolean':
      return [Ops.IS_TRUE, Ops.IS_FALSE];

    case 'text':
      return [
        Ops.EQUAL,
        Ops.NOT_EQUAL,
        Ops.CONTAINS,
        Ops.NOT_CONTAINS
      ];

    case 'long':
    case 'float':
      return [
        Ops.EQUAL,
        Ops.NOT_EQUAL,
        Ops.GREATER,
        Ops.LESS,
        Ops.GREATER_OR_EQUAL,
        Ops.LESS_OR_EQUAL,
        Ops.BETWEEN,
        Ops.EXCEPT
      ];

    default:
      throw new Error(`未知的数据类型: ${type}`);
  }
}

/**
 * 构建符合ElasticSearch格式的Query DSL
 * @param {Array} conditions - 每个元素为 { field, op, value }，value 可选，取决于 op
 *  对于二元运算符，value为包含两个元素的数组，对于一元运算符，value为标量值
 * @param {string} logic - 'and' | 'or'
 * @returns {Object} Elasticsearch 查询对象
 */
export function buildElasticQuery(conditions, logic = 'and') {
  const clauses = [];

  const filtered = conditions.filter(c => c.field && c.op && (c.value !== null || c.op === Ops.IS_TRUE || c.op === Ops.IS_FALSE));
  for (const cond of filtered) {
    const { field, op, value } = cond;

    switch (op) {
      case Ops.IS_TRUE:
        clauses.push({ term: { [field]: true } });
        break;
      case Ops.IS_FALSE:
        clauses.push({ term: { [field]: false } });
        break;

      case Ops.EQUAL:
        clauses.push({ term: { [field]: value } });
        break;
      case Ops.NOT_EQUAL:
        clauses.push({
          bool: { must_not: { term: { [field]: value } } }
        });
        break;

      case Ops.GREATER:
        clauses.push({ range: { [field]: { gt: value } } });
        break;
      case Ops.LESS:
        clauses.push({ range: { [field]: { lt: value } } });
        break;
      case Ops.GREATER_OR_EQUAL:
        clauses.push({ range: { [field]: { gte: value } } });
        break;
      case Ops.LESS_OR_EQUAL:
        clauses.push({ range: { [field]: { lte: value } } });
        break;

      case Ops.BETWEEN:
        if (!Array.isArray(value) || value.length !== 2) {
          throw new Error(`操作 "${op}" 的值必须是包含两个元素的数组`);
        }
        clauses.push({
          range: { [field]: { gte: value[0], lte: value[1] } }
        });
        break;
      case Ops.EXCEPT:
        if (!Array.isArray(value) || value.length !== 2) {
          throw new Error(`操作 "${op}" 的值必须是包含两个元素的数组`);
        }
        clauses.push({
          bool: {
            must_not: {
              range: { [field]: { gte: value[0], lte: value[1] } }
            }
          }
        });
        break;

      case Ops.CONTAINS:
        clauses.push({ match: { [field]: value } });
        break;
      case Ops.NOT_CONTAINS:
        clauses.push({
          bool: { must_not: { match: { [field]: value } } }
        });
        break;

      default:
        throw new Error(`不支持的操作: ${op}`);
    }
  }

  return {
    query: {
      bool: logic === 'and'
        ? { must: clauses }
        : { should: clauses, minimum_should_match: 1 }
    }
  };
}