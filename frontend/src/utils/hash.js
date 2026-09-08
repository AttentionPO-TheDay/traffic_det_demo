import SparkMD5 from "spark-md5";

// Asynchronously get the MD5 hash of a file
export async function getFileHash(file, chunkSize = 1024 * 1024) {
  const fileReader = new FileReader();
  const spark = new SparkMD5.ArrayBuffer();
  const totalChunks = Math.ceil(file.size / chunkSize);
  let currentChunk = 0;

  return new Promise((resolve, reject) => {
    fileReader.onload = (e) => {
      spark.append(e.target.result);
      currentChunk++;
  
      if (currentChunk < totalChunks) {
        loadNextChunk();
      } else {
        resolve(spark.end());
      }
    };
  
    fileReader.onerror = (error) => {
      reject(error);
    };
  
    function loadNextChunk() {
      const start = currentChunk * chunkSize;
      const end = Math.min(start + chunkSize, file.size);

      fileReader.readAsArrayBuffer(file.slice(start, end));
    }
  
    loadNextChunk();
  });
}