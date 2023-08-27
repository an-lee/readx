import { Controller } from '@hotwired/stimulus';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';
dayjs.extend(utc);
dayjs.extend(timezone);

export default class extends Controller {
  static values = {
    timestamp: String,
    format: String,
  };

  connect() {}

  timestampValueChanged(value) {
    console.log(value)
    if (!this.timestampValue) {
      return;
    }

    let time;
    const timestamp = dayjs.unix(this.timestampValue);

    if (timestamp.isBefore(dayjs().startOf('year'))) {
      time = timestamp.format('lll');
    } else if (timestamp.isBefore(dayjs().startOf('day'))) {
      time = timestamp.format('MM/DD HH:mm');
    } else if (timestamp.isAfter(dayjs().startOf('day'))) {
      time = timestamp.format('MM/DD HH:mm');
    } else if (timestamp.isAfter(dayjs().startOf('year'))) {
      time = timestamp.format('lll');
    }

    this.element.innerText = time;
  }
}
