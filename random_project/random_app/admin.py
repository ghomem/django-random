from django.contrib import admin

from .models import Number

class NumberAdmin(admin.ModelAdmin):

    # we force the date to be format in a specific way
    list_display = ["number", "custom_gen_date"]

    def custom_gen_date(self,obj):
        return obj.gen_date.strftime("%Y-%m-%d %H:%M:%S")

    custom_gen_date.admin_order_field = 'gen_date'
    custom_gen_date.short_description = 'Generation timestamp'

admin.site.register(Number, NumberAdmin)


