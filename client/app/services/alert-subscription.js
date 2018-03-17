function AlertSubscription($resource) {
  const resource = $resource('redash/api/alerts/:alertId/subscriptions/:subscriberId', { alertId: '@alert_id', subscriberId: '@id' });
  return resource;
}

export default function init(ngModule) {
  ngModule.factory('AlertSubscription', AlertSubscription);
}
