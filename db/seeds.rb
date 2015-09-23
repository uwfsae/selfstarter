# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
PaymentOption.create(
    [
        {
            amount: 20.00,
            amount_display: '$20',
            description: '<strong>Tier 1: </strong>You deserve a big thankyou from us!  On top of that, your name will be included on the “Individual Sponsors” portion of our website.',
            shipping_desc: '',
            delivery_desc: '',
            limit: -1
        },
        {
            amount: 51.00,
            amount_display: '$51',
            description: '<strong>Tier 2: </strong>On top of all the rewards Tier 1 donors receive; Tier 2 donors will also have their names on one of the two cars that we are building this year.',
            shipping_desc: '',
            delivery_desc: '',
            limit: 250
        },
        {
            amount: 201.00,
            amount_display: '$201',
            description: '<strong>Tier 3: </strong>Tier 3 donors will receive all of the benefits of Tier 1 and 2 donors, as well as a team t-shirt and VIP seating at our unveiling event in May.',
            shipping_desc: '',
            delivery_desc: '',
            limit: -1
        },
        {
            amount: 301.00,
            amount_display: '$301',
            description: '<strong>Tier 4: </strong>You are awesome. We can\'t think of anything better to give you, but if we do think of something, you\'ll be first in line.',
            shipping_desc: '',
            delivery_desc: '',
            limit: -1
        }
    ])