class TamaraUrls {
  final String? checkoutUrl;
  final String? successUrl;
  final String? failedUrl;
  final String? cancelUrl;
  final bool authoriseOrder;
  final bool captureOrder;

  TamaraUrls({
    this.checkoutUrl,
    this.successUrl,
    this.failedUrl,
    this.cancelUrl,
    this.authoriseOrder = true,
    this.captureOrder = false,
  });
}
