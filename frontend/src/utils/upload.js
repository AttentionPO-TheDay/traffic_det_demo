// 打开操作系统原生的文件选择窗口
// accept指定过滤的文件类型
// multiple指定是否支持文件多选
export async function openFileUpload(options = {}) {
  const input = document.createElement('input');
  input.type = 'file';

  if (options.accept) input.accept = options.accept; // 文件类型限制，如 'image/*'
  if (options.multiple) input.multiple = true;       // 是否多选

  input.style.display = 'none'; // 隐藏元素
  document.body.appendChild(input); // 必须加入DOM（某些浏览器要求）

  return new Promise((resolve, reject) => {
    input.onchange = (e) => {
      const files = e.target.files;
      resolve(files);
      document.body.removeChild(input); // 清理DOM
    };

    input.click();
  });
}