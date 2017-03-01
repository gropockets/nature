$(function() {
	$('#contactForm').validator().on('submit', function (e) {
		if (e.isDefaultPrevented()) {
			alert('form is not valid');
		} else {
			e.preventDefault();
			//alert('form is valid');
			//var mydata = $("#contactForm").serialize();	
			var mydata = {
				Name: $("#name").val(),
				Email: $("#email").val(),
				Phone: $("#phone").val(),
				Message: $("#message").val()
			}
			//mydata = mydata + '&ml-submit=1&ajax=1';
			$.ajax({
				type: 'POST',
				url: 'https://formspree.io/admin@yogijunior.com',
				data: mydata,
				//data: {message: "hello!"},
				//data: 'fields%5Bname%5D=Eric&fields%5Bemail%5D=erichpowell%40gmail.com&fields%5Bphone%5D=0305+444+4444&fields%5Blikes%5D=&ml-submit=1&ajax=1',
				dataType: 'json',
				/* EP - Adjust for MailerLite
				   url: "././mail/contact_me.php",
				   type: "POST",
				   data: {
				   name: name,
				   phone: phone,
				   email: email,
				   message: message
				   },
				   cache: false,
				   */
				success: function() {
					// Success message
					$('#success').html("<div class='alert alert-success'>");
					$('#success > .alert-success').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
						.append("</button>");
					$('#success > .alert-success')
						.append("<strong>Your message has been sent. </strong>");
					$('#success > .alert-success')
						.append('</div>');

					//clear all fields
					$('#contactForm').trigger("reset");
				},
				error: function() {
					// Fail message
					$('#success').html("<div class='alert alert-danger'>");
					$('#success > .alert-danger').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
						.append("</button>");
					$('#success > .alert-danger').append("<strong>Sorry " + firstName + ", it seems that my our server is not responding. Please try again later!");
					$('#success > .alert-danger').append('</div>');
					//clear all fields
					$('#contactForm').trigger("reset");
				},
				// your ajax
			})
		}

	})
});

