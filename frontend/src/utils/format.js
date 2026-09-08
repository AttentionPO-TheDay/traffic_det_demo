import dayjs from "dayjs";

export function formatDataSize(size) {
  const units = ['B', 'KB', 'MB', 'GB'];
  const factor = 1024;

  let currentFactor = 1;
  for (let u of units) {
    if (size < currentFactor * factor) {
      return `${(size / currentFactor).toFixed(2)}${u}`;
    }
    currentFactor *= factor;
  }

  // GB is our largest unit
  currentFactor = 1024 ** 3;
  return `${(size / currentFactor).toFixed(2)}GB`;
}

export function formatUptime(time) {
  const hours = Math.round(time % (24 * 3600) / 3600);
  const days = Math.floor(time / (24 * 3600));

  return days > 0 ? `${days}天${hours}小时` : `${hours}小时`;
}

export function formatTimestamp(timestamp) {
  if (typeof(timestamp) === 'string') {
    timestamp = Number(timestamp);
  }
  return dayjs(timestamp).format("YYYY-MM-DD HH:mm:ss");
}
