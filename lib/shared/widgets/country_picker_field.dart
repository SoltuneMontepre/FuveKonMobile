import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CountryPickerField extends FormField<Country> {
  CountryPickerField({
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    ValueChanged<Country>? onChanged,
    required InputDecoration decoration,
    required String hintText,
    required TextStyle textStyle,
    required TextStyle hintStyle,
    required Color iconColor,
    bool enabled = true,
  }) : super(
         builder: (field) {
           final country = field.value;

           void openPicker() {
             if (!enabled) return;
             showCountryPicker(
               context: field.context,
               showPhoneCode: false,
               onSelect: (selected) {
                 field.didChange(selected);
                 onChanged?.call(selected);
               },
             );
           }

           return Opacity(
             opacity: enabled ? 1 : 0.55,
             child: InkWell(
               onTap: enabled ? openPicker : null,
               borderRadius: BorderRadius.circular(12),
               child: InputDecorator(
                 decoration: decoration.copyWith(
                   errorText: field.errorText,
                   hintText: country == null
                       ? (decoration.hintText ?? hintText)
                       : null,
                   hintStyle: country == null
                       ? (decoration.hintStyle ?? hintStyle)
                       : null,
                 ),
                 isEmpty: country == null,
                 child: Row(
                   children: [
                     if (country != null) ...[
                       Text(
                         country.flagEmoji,
                         style: const TextStyle(fontSize: 22),
                       ),
                       const SizedBox(width: 10),
                       Expanded(
                         child: Text(
                           country.getTranslatedName(field.context) ??
                               country.name,
                           style: textStyle,
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                     ] else
                       const Spacer(),
                     Icon(Icons.arrow_drop_down_rounded, color: iconColor),
                   ],
                 ),
               ),
             ),
           );
         },
       );
}
