$(document).on('blur',".priceclass", function() {
        if (parseInt($(this).val()) > 0) {
            var price = parseFloat($(this).val());
            split_values = $(this).attr('id').split('_');
            var quantity = $("#invoice_line_items_attributes_" + split_values[4] + "_quantity").val();
            var line_total = parseFloat(price) * parseFloat(quantity);
            if(!isNaN(parseFloat(line_total))) {
                var invoice_total = parseFloat($("#invoice_total").val()) - parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()) + parseFloat(line_total);
                $("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val(line_total);
                $($("#invoice_total").val(invoice_total));
            }
        }
    });

$(document).on('click',"#send_button", function() {
    $("#email_send").val("true");
    $(this).form.submit();
});

$(document).on('blur',".quantityclass", function() {
        var quantity = parseFloat($(this).val());
        split_values = $(this).attr('id').split('_');
        var price = $("#invoice_line_items_attributes_" + split_values[4] + "_price").val();
        var line_total = parseFloat(price) * parseFloat(quantity);
        if(!isNaN(parseFloat(line_total))) {
            var invoice_total = parseFloat($("#invoice_total").val()) - parseFloat($("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val()) + parseFloat(line_total);
            $("#invoice_line_items_attributes_" + split_values[4] + "_line_total").val(line_total);
            $($("#invoice_total").val(invoice_total));
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

$(document).on('change',".currency_select", function() {
    $("#show_currency").html("Invoice Total ("+$(this).val().toUpperCase()+") : ")
});

$(document).on('click',".remove_items", function() {
    var nested_div_object = $(this).closest(".nested-fields");
    var hidden_object = $(this).prev("input[type=hidden]").attr('id');
    split_values = hidden_object.toString().split('_');
    var line_total = $("#invoice_line_items_attributes_"+split_values[4]+"_line_total").val();
    if(parseFloat(line_total) > 0.00 && !isNaN(parseFloat(line_total)) && line_total.toString() != '')
    {
        var invoice_total = parseFloat($("#invoice_total").val())-parseFloat(line_total);
        $($("#invoice_total").val(invoice_total));
    }
});

function selectfailure(id){
    var invoice_total = parseFloat($("#invoice_total").val()) - parseFloat($("#invoice_line_items_attributes_"+id+"_line_total").val());
    if(invoice_total <= 0.01)
        invoice_total = 0.00
    $($("#invoice_total").val(invoice_total));
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
    $($("#invoice_line_items_attributes_"+form_id+"_price").val(data["data"].item.price));
    $($("#invoice_line_items_attributes_"+form_id+"_quantity").val("1"));
    var line_total = parseFloat(data["data"].item.price * 1)
    $($("#invoice_line_items_attributes_"+form_id+"_line_total").val(line_total));
    var invoice_total = parseFloat($("#invoice_total").val()) - temp+parseFloat(line_total);
    $($("#invoice_total").val(invoice_total));
}

function remove_line_item(ele) {
    var nested_div_object = $(ele).closest(".nested-fields");
    var hidden_object = $(ele).prev("input[type=hidden]").attr('id');
    split_values = hidden_object.toString().split('_');
    var line_total = $("#invoice_line_items_attributes_"+split_values[4]+"_line_total").val();
    if(parseFloat(line_total) > 0.00 && !isNaN(parseFloat(line_total)) && line_total.toString() != '')
    {
        var invoice_total = parseFloat($("#invoice_total").val())-parseFloat(line_total);
        $($("#invoice_total").val(invoice_total));
    }
}