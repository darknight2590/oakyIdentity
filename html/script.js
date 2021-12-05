window.addEventListener('message', function (e) {
    if (e.data.action == 'sendIdentity') {
        const prefix = 'idcard'
        $('.' + prefix + 'Firstname').html(e.data.userData.firstname)
        $('.' + prefix + 'Lastname').html(e.data.userData.lastname)
        $('.' + prefix + 'CID').html(e.data.userData.cid)
        $('.' + prefix + 'Birthday').html(e.data.userData.birthday)
        $('.' + prefix + 'Sex').html(e.data.userData.sex == 'm' ? 'Männlich' : 'Weiblich')
        $('#idCardSignature').html(e.data.userData.firstname + " " + e.data.userData.lastname)

        $('.identification').fadeIn()
    } else if (e.data.action == 'sendWeapon') {
        $('.weaponFirstname').html(e.data.data.firstname)
        $('.weaponLastname').html(e.data.data.lastname)
        $('.weaponSignature').html(e.data.data.firstname + " " + e.data.data.lastname)

        $('.weaponSex').html(e.data.data.sex == 'm' ? 'Male' : 'Female')

        $('.weapon').fadeIn()
    } else if (e.data.action == 'close') {
        $('.identification').fadeOut()
        $('.weapon').fadeOut()
        $('.license').fadeOut()
    } else if (e.data.action == 'sendLicense') {
        const licenses = e.data.licenses
        let textString = ''
        for (let i = 0; i < licenses.length; i++) {
            if (i == 0) {
                if (licenses[i].type == 'drive') {
                    textString += 'Car'
                } else if (licenses[i].type == 'drive_truck') {
                    textString += 'Truck'
                } else if (licenses[i].type == 'drive_bike') {
                    textString += 'Motorcycle'
                } else if (licenses[i].type == 'weapon') {

                }
            } else if (i == licenses.length) {
                if (licenses[i].type == 'drive') {
                    textString += ', Car'
                } else if (licenses[i].type == 'drive_truck') {
                    textString += ', Truck'
                } else if (licenses[i].type == 'drive_bike') {
                    textString += ', Motorcycle'
                } else if (licenses[i].type == 'weapon') {

                }
            } else {
                if (licenses[i].type == 'drive') {
                    textString += ', Car'
                } else if (licenses[i].type == 'drive_truck') {
                    textString += ', Truck'
                } else if (licenses[i].type == 'drive_bike') {
                    textString += ', Motorcycle'
                } else if (licenses[i].type == 'weapon') {
    
                }
            }
        }
        $('.licenseFirstname').html(e.data.data.firstname)
        $('.licenseLastname').html(e.data.data.lastname)
        $('.licenseTypes').html(textString)
        $('.licenseSignature').html(e.data.data.firstname + " " + e.data.data.lastname)
        $('.licenseIssuedAt').html(new Date(e.data.licenses[0].time).toLocaleDateString("de-DE") ?? '')
        $('.licenseSex').html(e.data.data.sex == 'm' ? 'Male' : 'Female')

        $('.license').fadeIn()
    }
})

