class ProductResponse {
    ProductResponse({
        required this.message,
        required this.data,
    });

    final String? message;
    final List<Datum> data;

    factory ProductResponse.fromJson(Map<String, dynamic> json){ 
        return ProductResponse(
            message: json["message"],
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.id,
        required this.productName,
        required this.productShortDescription,
        required this.productPrice,
        required this.productImage,
        required this.productSku,
        required this.productType,
        required this.stockStatus,
    });

    final String? id;
    final String? productName;
    final String? productShortDescription;
    final int? productPrice;
    final String? productImage;
    final String? productSku;
    final int? productType;
    final String? stockStatus;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["_id"],
            productName: json["productName"],
            productShortDescription: json["productShortDescription"],
            productPrice: json["productPrice"],
            productImage: json["productImage"],
            productSku: json["productSKU"],
            productType: json["productType"],
            stockStatus: json["stockStatus"],
        );
    }

}
