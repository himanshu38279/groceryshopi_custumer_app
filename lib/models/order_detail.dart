import 'package:tbo_the_best_one/api/api_routes.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';
import 'package:tbo_the_best_one/utilities/helpers.dart';

class OrderDetail {
  String id;
  String date;
  String referenceNo;
  String customerId;
  String customer;
  String billerId;
  String biller;
  String warehouseId;
  String note;
  String staffNote;
  String total;
  String productDiscount;
  String orderDiscountId;
  String totalDiscount;
  String orderDiscount;
  String productTax;
  String orderTaxId;
  String orderTax;
  String totalTax;
  String shipping;
  double grandTotal;
  String saleStatus;
  String paymentStatus;
  String paymentTerm;
  String dueDate;
  String createdBy;
  String updatedBy;
  String updatedAt;
  String totalItems;
  String pos;
  String paid;
  String returnId;
  String surcharge;
  String attachment;
  String returnSaleRef;
  String saleId;
  String returnSaleTotal;
  String rounding;
  String suspendNote;
  String api;
  String shop;
  String addressId;
  String reserveId;
  String hash;
  String manualPayment;
  String cgst;
  String sgst;
  String igst;
  String paymentMethod;
  List<OrderProduct> orderProducts;

  String get totalAsString =>
      "$kRupeeSymbol ${this.grandTotal.toStringAsFixed(1)}";

  OrderDetail(
      {this.id,
      this.date,
      this.referenceNo,
      this.customerId,
      this.customer,
      this.billerId,
      this.biller,
      this.warehouseId,
      this.note,
      this.staffNote,
      this.total,
      this.productDiscount,
      this.orderDiscountId,
      this.totalDiscount,
      this.orderDiscount,
      this.productTax,
      this.orderTaxId,
      this.orderTax,
      this.totalTax,
      this.shipping,
      this.grandTotal,
      this.saleStatus,
      this.paymentStatus,
      this.paymentTerm,
      this.dueDate,
      this.createdBy,
      this.updatedBy,
      this.updatedAt,
      this.totalItems,
      this.pos,
      this.paid,
      this.returnId,
      this.surcharge,
      this.attachment,
      this.returnSaleRef,
      this.saleId,
      this.returnSaleTotal,
      this.rounding,
      this.suspendNote,
      this.api,
      this.shop,
      this.addressId,
      this.reserveId,
      this.hash,
      this.manualPayment,
      this.cgst,
      this.sgst,
      this.igst,
      this.paymentMethod,
      this.orderProducts});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    referenceNo = json['reference_no'];
    customerId = json['customer_id'];
    customer = json['customer'];
    billerId = json['biller_id'];
    biller = json['biller'];
    warehouseId = json['warehouse_id'];
    note = json['note'];
    staffNote = json['staff_note'];
    total = json['total'];
    productDiscount = json['product_discount'];
    orderDiscountId = json['order_discount_id'];
    totalDiscount = json['total_discount'];
    orderDiscount = json['order_discount'];
    productTax = json['product_tax'];
    orderTaxId = json['order_tax_id'];
    orderTax = json['order_tax'];
    totalTax = json['total_tax'];
    shipping = json['shipping'];
    grandTotal = double.tryParse(json['grand_total']);
    saleStatus = (json['sale_status'] ?? "").toUpperCase();
    paymentStatus = json['payment_status'];
    paymentTerm = json['payment_term'];
    dueDate = json['due_date'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    totalItems = json['total_items'];
    pos = json['pos'];
    paid = json['paid'];
    returnId = json['return_id'];
    surcharge = json['surcharge'];
    attachment = json['attachment'];
    returnSaleRef = json['return_sale_ref'];
    saleId = json['sale_id'];
    returnSaleTotal = json['return_sale_total'];
    rounding = json['rounding'];
    suspendNote = json['suspend_note'];
    api = json['api'];
    shop = json['shop'];
    addressId = json['address_id'];
    reserveId = json['reserve_id'];
    hash = json['hash'];
    manualPayment = json['manual_payment'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    igst = json['igst'];
    paymentMethod = json['payment_method'];
    if (json['order_products'] != null) {
      orderProducts = <OrderProduct>[];
      json['order_products'].forEach((v) {
        orderProducts.add(new OrderProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['date'] = this.date;
    data['reference_no'] = this.referenceNo;
    data['customer_id'] = this.customerId;
    data['customer'] = this.customer;
    data['biller_id'] = this.billerId;
    data['biller'] = this.biller;
    data['warehouse_id'] = this.warehouseId;
    data['note'] = this.note;
    data['staff_note'] = this.staffNote;
    data['total'] = this.total;
    data['product_discount'] = this.productDiscount;
    data['order_discount_id'] = this.orderDiscountId;
    data['total_discount'] = this.totalDiscount;
    data['order_discount'] = this.orderDiscount;
    data['product_tax'] = this.productTax;
    data['order_tax_id'] = this.orderTaxId;
    data['order_tax'] = this.orderTax;
    data['total_tax'] = this.totalTax;
    data['shipping'] = this.shipping;
    data['grand_total'] = this.grandTotal;
    data['sale_status'] = this.saleStatus;
    data['payment_status'] = this.paymentStatus;
    data['payment_term'] = this.paymentTerm;
    data['due_date'] = this.dueDate;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    data['total_items'] = this.totalItems;
    data['pos'] = this.pos;
    data['paid'] = this.paid;
    data['return_id'] = this.returnId;
    data['surcharge'] = this.surcharge;
    data['attachment'] = this.attachment;
    data['return_sale_ref'] = this.returnSaleRef;
    data['sale_id'] = this.saleId;
    data['return_sale_total'] = this.returnSaleTotal;
    data['rounding'] = this.rounding;
    data['suspend_note'] = this.suspendNote;
    data['api'] = this.api;
    data['shop'] = this.shop;
    data['address_id'] = this.addressId;
    data['reserve_id'] = this.reserveId;
    data['hash'] = this.hash;
    data['manual_payment'] = this.manualPayment;
    data['cgst'] = this.cgst;
    data['sgst'] = this.sgst;
    data['igst'] = this.igst;
    data['payment_method'] = this.paymentMethod;
    if (this.orderProducts != null) {
      data['order_products'] =
          this.orderProducts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderProduct {
  String id;
  String saleId;
  String productId;
  String productCode;
  String productName;
  String productType;
  String optionId;
  String netUnitPrice;
  String unitPrice;
  String quantity;
  String warehouseId;
  String itemTax;
  String taxRateId;
  String tax;
  String discount;
  String itemDiscount;
  String image;
  String subtotal;
  String serialNo;
  double realUnitPrice;
  String saleItemId;
  String productUnitId;
  String productUnitCode;
  String unitQuantity;
  String comment;
  String gst;
  String cgst;
  String sgst;
  String igst;

  String get unitPriceAsString =>
      "$kRupeeSymbol ${realUnitPrice.toStringAsFixed(1)}";

  OrderProduct({
    this.id,
    this.saleId,
    this.productId,
    this.productCode,
    this.productName,
    this.productType,
    this.optionId,
    this.netUnitPrice,
    this.unitPrice,
    this.quantity,
    this.warehouseId,
    this.itemTax,
    this.taxRateId,
    this.tax,
    this.discount,
    this.itemDiscount,
    this.subtotal,
    this.serialNo,
    this.realUnitPrice,
    this.saleItemId,
    this.productUnitId,
    this.productUnitCode,
    this.unitQuantity,
    this.comment,
    this.gst,
    this.cgst,
    this.sgst,
    this.igst,
  });

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    saleId = json['sale_id'];
    productId = json['product_id'];
    productCode = json['product_code'];
    productName = Helpers.capitalize(json['product_name']);
    image = json['image'] == null ? null : ApiRoutes.getImageUrl(json['image']);
    productType = json['product_type'];
    optionId = json['option_id'];
    netUnitPrice = json['net_unit_price'];
    unitPrice = json['unit_price'];
    quantity = double.tryParse(json['quantity']).toStringAsFixed(0);
    warehouseId = json['warehouse_id'];
    itemTax = json['item_tax'];
    taxRateId = json['tax_rate_id'];
    tax = json['tax'];
    discount = json['discount'];
    itemDiscount = json['item_discount'];
    subtotal = json['subtotal'];
    serialNo = json['serial_no'];
    realUnitPrice = double.tryParse(json['real_unit_price']);
    saleItemId = json['sale_item_id'];
    productUnitId = json['product_unit_id'];
    productUnitCode = json['product_unit_code'];
    unitQuantity = json['unit_quantity'];
    comment = json['comment'];
    gst = json['gst'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    igst = json['igst'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['sale_id'] = this.saleId;
    data['product_id'] = this.productId;
    data['product_code'] = this.productCode;
    data['product_name'] = this.productName;
    data['product_type'] = this.productType;
    data['option_id'] = this.optionId;
    data['net_unit_price'] = this.netUnitPrice;
    data['unit_price'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['warehouse_id'] = this.warehouseId;
    data['item_tax'] = this.itemTax;
    data['tax_rate_id'] = this.taxRateId;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['item_discount'] = this.itemDiscount;
    data['subtotal'] = this.subtotal;
    data['serial_no'] = this.serialNo;
    data['real_unit_price'] = this.realUnitPrice;
    data['sale_item_id'] = this.saleItemId;
    data['product_unit_id'] = this.productUnitId;
    data['product_unit_code'] = this.productUnitCode;
    data['unit_quantity'] = this.unitQuantity;
    data['comment'] = this.comment;
    data['gst'] = this.gst;
    data['cgst'] = this.cgst;
    data['sgst'] = this.sgst;
    data['igst'] = this.igst;
    return data;
  }
}
