$(document).on('blur',".priceclass", function() {
    if (parseInt($(this).val()) < 0) {
        $(this).val(Math.abs($(this).val()));
    }
    var price = parseFloat($(this).val());
    split_values = $(this).attr('id').split('_');
    if($("#invoice_line_items_attributes_" + split_values[4] + "_discount").val() == "")
        $("#invoice_line_items_attributes_" + split_values[4] + "_discount").val('0.00');
    if($("#invoice_line_items_attributes_" + split_values[4] + "_quantity").val() == "")
        $("#invoice_line_items_attributes_" + split_values[4] + "_quantity").val('1.00');
    var quantity = $("#invoice_line_items_attributes_" + split_values[4] + "_quantity").val();
    var discount_value = ((parseFloat(price) * parseFloat(quantity))*parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_discount").val()))/100.00;
    var line_total = (parseFloat(price) * parseFloat(quantity)) - discount_value
    if(!isNaN(parseFloat(line_total))) {
        var invoice_total = parseFloat($("#invoice_total").val()) - parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()) + parseFloat(line_total);
        $("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val(line_total.toFixed(2));
        $($("#invoice_total").val(invoice_total.toFixed(2)));
        calculateTotal();
        calculateTax();
    }
});

$(document).on('click',"#send_button", function() {
    $("#email_send").val("true");
    $("#submit_button").removeAttr('data-disable-with');
    $(this).form.submit();
});

$(document).on('click',"#submit_button", function() {
    $("#send_button").removeAttr('data-disable-with');
    $(this).form.submit();
});

$(document).on('blur',".quantityclass", function() {
    if (parseInt($(this).val()) < 0) {
        $(this).val(Math.abs($(this).val()));
    }
    var quantity = parseFloat($(this).val());
    split_values = $(this).attr('id').split('_');
    if($("#invoice_line_items_attributes_" + split_values[4] + "_discount").val() == "")
        $("#invoice_line_items_attributes_" + split_values[4] + "_discount").val('0.00');
    var price = $("#invoice_line_items_attributes_" + split_values[4] + "_price").val();
    var discount_value = ((parseFloat(price) * parseFloat(quantity))*parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_discount").val()))/100.00;
    var line_total = (parseFloat(price) * parseFloat(quantity)) - discount_value
    if(!isNaN(parseFloat(line_total))) {
        var invoice_total = parseFloat($("#invoice_total").val()) - parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()) + parseFloat(line_total);
        $("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val(line_total.toFixed(2));
        $($("#invoice_total").val(invoice_total.toFixed(2)));
        calculateTotal();
        calculateTax();
    }
});

$(document).on('blur',"#invoice_discount", function() {
    if (parseInt($(this).val()) < 0) {
        $(this).val(Math.abs($(this).val()));
    }
    if($(this).val() == "")
        $(this).val('0.00');
    if(!isNaN(parseFloat($("#invoice_total").val()))) {
        var total = 0
        $('[id$="_line_total"]').each(function() {
            if ( $(this).is(':visible') && !isNaN(parseFloat($( this ).val()))) {
                total = total + parseFloat($(this).val());
            }
        });
        $("#invoice_total").val(total);
        var invoice_total = parseFloat($("#invoice_total").val()) - ((parseFloat($("#invoice_discount").val())/100.00)*parseFloat($("#invoice_total").val()))
        $($("#invoice_total").val(invoice_total.toFixed(2)));
    }
});

$(document).on('blur',".discountclass", function() {
    if (parseInt($(this).val()) < 0) {
        $(this).val(Math.abs($(this).val()));
    }
    split_values = $(this).attr('id').split('_');
    if($(this).val() == "")
        $(this).val('0.00');
    var discount = parseFloat($(this).val());
    var price = $("#invoice_line_items_attributes_" + split_values[4] + "_price").val();
    var quantity = $("#invoice_line_items_attributes_" + split_values[4] + "_quantity").val();
    var discount_value = ((parseFloat(price) * parseFloat(quantity))*parseFloat(discount))/100.00;
    var line_total = (parseFloat(price) * parseFloat(quantity)) - discount_value
    if(!isNaN(parseFloat(line_total))) {
        var invoice_total = parseFloat($("#invoice_total").val()) - parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()) + parseFloat(line_total);
        $("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val(line_total.toFixed(2));
        $($("#invoice_total").val(invoice_total.toFixed(2)));
        calculateTotal();
        calculateTax();
    }
});

$(document).on('change',".selectclass", function() {
    split_values = $(this).attr('id').split('_');
    $.ajax({
        type: 'POST',
        url: '/items/populate_values_of_item',
        data: { form_id: split_values[4], item_id: $(this).val() },
        dataType: 'json',
        error: function(xhr, error){
            selectfailure(split_values[4])
        },
        success: function (data) {
            selectsuccess(data,split_values[4])
        }
    });
});

$(document).on('change',".selecttax", function() {
    calculateTax();
});

$(document).on('change',".selectclient", function() {
    split_values = $(this).attr('id').split('_');
    $.ajax({
        type: 'POST',
        url: '/clients/'+$(this).val()+'/address',
        data: { id: $(this).val() },
        dataType: 'json',
        error: function(xhr, error){

        },
        success: function (data) {
            var addresss = data.street_1+" "+data.street_2+", <br/>"+data.city+", "+data.state+", <br/>"+data.pincode.toString();
            $("#client_address").html(addresss);
        }
    });
});

function calculateTax(){
    $('[id^="tax_"]').each(function() {
        $(this).val('0.00');
    });
    var count = 0;
    var total = 0.00;
    $('[id$="_tax1"]').each(function() {
        if ($(this).is(':visible') && !isNaN(parseFloat($( this ).val()))) {
            split_values = $(this).attr('id').split('_');
            if(!isNaN(parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()))) {
                var amt = parseFloat($("#tax_" + $(this).val().toString()).val()) + (parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()) * (parseFloat($("#rate_" + $(this).val().toString()).val()) / 100.00));
                $("#tax_" + $(this).val().toString()).val(amt.toFixed(2));
                if ( $( "#parent_"+$(this).val() ).length ) {
                    var amt = parseFloat($("#tax_" +  $("#parent_"+$(this).val()).val().toString()).val()) + (parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()) * (parseFloat($("#rate_" + $("#parent_"+$(this).val()).val().toString()).val()) / 100.00));
                    $("#tax_" + $("#parent_"+$(this).val()).val()).val(amt.toFixed(2));
                }
            }
        }
        if ($(this).is(':visible'))
            count++;
    });
    $('[id$="_tax2"]').each(function() {
        if ($(this).is(':visible') && !isNaN(parseFloat($( this ).val()))) {
            split_values = $(this).attr('id').split('_');
            if(!isNaN(parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()))) {
                var amt = parseFloat($("#tax_" + $(this).val().toString()).val()) + (parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()) * (parseFloat($("#rate_" + $(this).val().toString()).val()) / 100.00));
                $("#tax_" + $(this).val().toString()).val(amt.toFixed(2));
                if ( $( "#parent_"+$(this).val() ).length ) {
                    var amt = parseFloat($("#tax_" +  $("#parent_"+$(this).val()).val().toString()).val()) + (parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()) * (parseFloat($("#rate_" + $("#parent_"+$(this).val()).val().toString()).val()) / 100.00));
                    $("#tax_" + $("#parent_"+$(this).val()).val()).val(amt.toFixed(2));
                }
            }
        }
        if ($(this).is(':visible'))
            count++;
    });
    $('[id^="tax_"]').each(function() {
        total = total + parseFloat($(this).val());
    });
    $("#grand_total").val((parseFloat($("#invoice_total").val())+total).toFixed(2));
    if(count == 2 && parseInt($("#invoice_total").val()) == 0) {
        $('[id^="tax_"]').each(function () {
            $(this).val('0.00');
        });
        $("#grand_total").val('0.00');
    }
}

function calculateTotal(){
    var total = 0.00;
    $('[id$="_line_total"]').each(function() {
        if ( $(this).is(':visible') && !isNaN(parseFloat($( this ).val()))) {
            total = total + parseFloat($(this).val());
        }
    });
    $("#line_total").val(total.toFixed(2));
    $("#invoice_discount").val("0.00");
    $("#invoice_total").val(total.toFixed(2));
}

$(document).on('change',".currency_select", function() {
    $("#show_currency").html("Invoice Total ("+$(this).val().toUpperCase()+") : ")
});

$(document).on('click',".remove_items", function() {
    var nested_div_object = $(this).closest(".nested-fields");
    var hidden_object = $(this).prev("input[type=hidden]").attr('id');
    split_values = hidden_object.toString().split('_');
    var line_total = $("#invoice_line_items_attributes_"+split_values[4]+"_line_total").val();
    if($("#invoice_discount").val() == "")
        $("#invoice_discount").val("0.00");
    if(parseFloat(line_total) > 0.00 && !isNaN(parseFloat(line_total)) && line_total.toString() != '')
    {
        var total = 0.00
        $('[id$="_line_total"]').each(function() {
            if ( $(this).is(':visible') && !isNaN(parseFloat($( this ).val()))) {
                total = total + parseFloat($(this).val());
            }
        });
        total = total - line_total;
        $($("#line_total").val(total.toFixed(2)));
        if(total > 0) {
            var invoice_total = total - (parseFloat($("#invoice_discount").val()) * total / 100.00);
            $($("#invoice_total").val(invoice_total.toFixed(2)));
        }
        else
        {
            $($("#invoice_total").val('0.00'));
        }

    }
    calculateTax();
});

function selectfailure(id){
    var invoice_total = parseFloat($("#invoice_total").val()) - parseFloat($("#invoice_line_items_attributes_"+id+"_line_total").val());
    if(invoice_total <= 0.01)
        invoice_total = 0.00
    $($("#invoice_total").val(invoice_total.toFixed(2)));
    $($("#invoice_line_items_attributes_"+id+"_description").val(''));
    $($("#invoice_line_items_attributes_"+id+"_price").val(''));
    $($("#invoice_line_items_attributes_"+id+"_quantity").val(""));
    $($("#invoice_line_items_attributes_"+id+"_line_total").val(''));
}

function selectsuccess(data,form_id) {
    var temp = 0.00;
    $($("#invoice_line_items_attributes_"+form_id+"_description").val(data["data"].item.description));
    if($("#invoice_line_items_attributes_"+form_id+"_price").val() != "")
        temp = parseFloat($("#invoice_line_items_attributes_"+form_id+"_line_total").val());
    else
        temp = 0.00;
    $($("#invoice_line_items_attributes_"+form_id+"_price").val(data["data"].item.price.toFixed(2)));
    $($("#invoice_line_items_attributes_"+form_id+"_quantity").val("1.00"));
    $($("#invoice_line_items_attributes_"+form_id+"_discount").val("0.00"));
    var line_total = parseFloat(data["data"].item.price * 1)
    $($("#invoice_line_items_attributes_"+form_id+"_line_total").val(line_total.toFixed(2)));
    var invoice_total = parseFloat($("#invoice_total").val()) - temp+parseFloat(line_total);
    $($("#invoice_total").val(invoice_total.toFixed(2)));
    var total = 0
    $('[id$="_line_total"]').each(function() {
        if ( $(this).is(':visible') && !isNaN(parseFloat($( this ).val()))) {
            total = total + parseFloat($(this).val());
        }
    });
    $("#line_total").val(total.toFixed(2));
    calculateTax();
}