// Module-level store so subscription state is shared across all hook instances
let _isSubscribed = false;
let _isIAPReady = false;
let _offerings = null;
const _listeners = new Set();

function notify() {
  _listeners.forEach((fn) => fn());
}

export const iapStore = {
  get isSubscribed() {
    return _isSubscribed;
  },
  get isIAPReady() {
    return _isIAPReady;
  },
  get offerings() {
    return _offerings;
  },
  setSubscribed(val) {
    _isSubscribed = val;
    notify();
  },
  setReady(val) {
    _isIAPReady = val;
    notify();
  },
  setOfferings(val) {
    _offerings = val;
    notify();
  },
  subscribe(fn) {
    _listeners.add(fn);
    return () => _listeners.delete(fn);
  },
};
