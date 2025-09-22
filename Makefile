format:
	black custom_components tests
	isort custom_components tests

check:
	black custom_components tests --check
	isort custom_components tests --check

test:
	pytest

homeassistant:
	killall hass || true
	hass -c /config