"""
Test for models.
"""

from django.test import TestCase
from django.contrib.auth import get_user_model
# To get refernce for our custom model

class ModelTests(TestCase):
    """ Test Models """

    def test_create_user_with_mail_successful(self):
        """ Test creating a user with an email successful """
        email = 'test@example.com'
        password = 'testpass123'
        user = get_user_model().objects.create_user(
            email = email,
            password = password,
        )
        self.assertEqual(user.email,email)
        self.assertTrue(user.check_password(password))
        # Password is checked through hashing system.



