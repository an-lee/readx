import { Controller } from "@hotwired/stimulus";
import dayjs from "dayjs";
import "dayjs/locale/zh";
import utc from "dayjs/plugin/utc";
import timezone from "dayjs/plugin/timezone";
import relativeTime from "dayjs/plugin/relativeTime";

dayjs.extend(utc);
dayjs.extend(timezone);
dayjs.extend(relativeTime);

export default class extends Controller {
  static values = {
    timestamp: String,
    locale: {
      type: String,
      default: "en",
    },
    format: String,
  };

  connect() {}

  timestampValueChanged(value) {
    if (!value) return;

    this.refreshTimeDisplay();
  }

  refreshTimeDisplay() {
    if (!this.timestampValue) return;

    let time;
    const timestamp = dayjs.unix(this.timestampValue);

    if (timestamp.isBefore(dayjs().subtract(7, "day"))) {
      time = timestamp.format("MM/DD/YYYY");
    } else {
      const locale = this.localeValue.split("-")[0];
      time = timestamp.locale(locale).fromNow();
    }
    this.element.innerText = time;

    this.scheduleRefresh();
  }

  scheduleRefresh() {
    if (!this.timestampValue) return;

    const timestamp = dayjs.unix(this.timestampValue);

    if (timestamp.isAfter(dayjs().subtract(1, "minute"))) {
      this.timer = setTimeout(() => {
        this.refreshTimeDisplay();
      }, 1000 * 10);
    } else if (timestamp.isAfter(dayjs().subtract(10, "minute"))) {
      this.timer = setTimeout(() => {
        this.refreshTimeDisplay();
      }, 1000 * 60);
    } else if (timestamp.isAfter(dayjs().subtract(1, "hour"))) {
      this.timer = setTimeout(() => {
        this.refreshTimeDisplay();
      }, 1000 * 60 * 5);
    } else if (timestamp.isAfter(dayjs().subtract(10, "hour"))) {
      this.timer = setTimeout(() => {
        this.refreshTimeDisplay();
      }, 1000 * 60 * 30);
    }
  }

  disconnect() {
    if (this.timer) clearTimeout(this.timer);
  }
}
