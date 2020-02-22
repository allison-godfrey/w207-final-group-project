.PHONY: jupyter
jupyter:
	docker start jupyter-tensorflow 2>/dev/null || \
		docker run -d -p 127.0.0.1:8888:8888 \
		-e JUPYTER_ENABLE_LAB=yes \
		-v $(PWD):/home/jovyan/work \
		--name jupyter-tensorflow \
		jupyter/tensorflow-notebook:7a0c7325e470
		@make --no-print-directory jupyter-url

.PHONY: jupyter-url
jupyter-url:
	@while true; do \
		url=$$(docker logs jupyter-tensorflow 2>&1 | egrep -o 'http://127.0.0.1:8888/\?token=[0-9a-f]+' | tail -1); \
		if [ -z "$$url" ]; then \
			sleep 1; \
		else \
			echo "Jupyter URL: $$url"; \
			break; \
		fi; \
	done

.PHONY: stop-jupyter
stop-jupyter:
	docker kill jupyter-tensorflow || true

.PHONY: kill-jupyter
kill-jupyter: stop-jupyter
	docker rm jupyter-tensorflow
