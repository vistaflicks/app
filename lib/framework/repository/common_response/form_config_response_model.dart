// To parse this JSON data, do
//
//     final formConfigResponeModel = formConfigResponeModelFromJson(jsonString);

import 'dart:convert';

FormConfigResponeModel formConfigResponeModelFromJson(String str) =>
    FormConfigResponeModel.fromJson(json.decode(str));

String formConfigResponeModelToJson(FormConfigResponeModel data) =>
    json.encode(data.toJson());

class FormConfigResponeModel {
  List<FormModel>? data;

  FormConfigResponeModel({
    this.data,
  });

  factory FormConfigResponeModel.fromJson(Map<String, dynamic> json) =>
      FormConfigResponeModel(
        data: json['data'] == null
            ? []
            : List<FormModel>.from(
                json['data']!.map((x) => FormModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FormModel {
  String? id;
  String? title;
  List<Field>? fields;

  FormModel({
    this.id,
    this.title,
    this.fields,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) => FormModel(
        id: json['id'],
        title: json['title'],
        fields: json['fields'] == null
            ? []
            : List<Field>.from(json['fields']!.map((x) => Field.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'fields': fields == null
            ? []
            : List<dynamic>.from(fields!.map((x) => x.toJson())),
      };
}

class Field {
  String? id;
  String? type;
  String? title;
  String? fieldName;
  String? hintText;
  String? textInputType;
  List<String>? option;
  String? errorMsg;
  String? fieldValue;
  List<Field>? mapTextFields;
  String? latLng;
  bool? isPickUpAndDrop;

  Field({
    this.id,
    this.type,
    this.title,
    this.fieldName,
    this.hintText,
    this.textInputType,
    this.option,
    this.errorMsg,
    this.fieldValue,
    this.mapTextFields,
    this.latLng,
    this.isPickUpAndDrop,
  });

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        id: json['id'],
        type: json['type'],
        title: json['title'],
        fieldName: json['fieldName'],
        hintText: json['hintText'],
        textInputType: json['textInputType'],
        option: json['option'] == null
            ? []
            : List<String>.from(json['option']!.map((x) => x)),
        errorMsg: json['errorMsg'],
        fieldValue: json['value'],
        mapTextFields: json['maps_text_fields'] == null
            ? []
            : List<Field>.from(
                json['maps_text_fields']!.map((x) => Field.fromJson(x))),
        latLng: json['latLng'],
        isPickUpAndDrop: json['is_pick_up_and_drop'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'fieldName': fieldName,
        'hintText': hintText,
        'textInputType': textInputType,
        'option':
            option == null ? [] : List<dynamic>.from(option!.map((x) => x)),
        'errorMsg': errorMsg,
        'value': fieldValue,
        'maps_text_fields': mapTextFields == null
            ? []
            : List<dynamic>.from(mapTextFields!.map((x) => x.toJson())),
        'latLng': latLng,
        'is_pick_up_and_drop': isPickUpAndDrop,
      };
}
