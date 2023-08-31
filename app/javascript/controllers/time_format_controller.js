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
    if (!value) {
      return;
    }

    let time;
    const timestamp = dayjs.unix(value);

    if (timestamp.isBefore(dayjs().subtract(7, "day"))) {
      time = timestamp.format("MM/DD/YYYY");
    } else {
      const locale = this.localeValue.split("-")[0];
      time = timestamp.locale(locale).fromNow();
    }

    this.element.innerText = time;
  }
}
